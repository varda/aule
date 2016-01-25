# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Todo: Figure out roles and rights for variant lookup.


$ = require 'jquery'
Promise = require 'bluebird'
Sammy = require 'sammy'

config = require 'config'


app = Sammy '#main', ->

  # Always call init() with an initialized Api instance before calling run().
  @init = (api) => @api = api

  # Create pagination data for use in template.
  createPagination = (total, current=0) ->
    if total <= 1 then return null
    pagination =
      pages: for p in [0...total]
        page: p
        label: p + 1
        active: p == current
      many_pages: total >= config.MANY_PAGES
    if current > 0
      pagination.previous = page: current - 1, label: current
    if current < total - 1
      pagination.next = page: current + 1, label: current + 2
    pagination

  # Create authentication data for use in template.
  createAuth = () =>
    return null unless @api.current_user?
    roles = @api.current_user.roles
    user: @api.current_user
    roles:
      admin: 'admin' in roles
      importer: 'importer' in roles
      annotator: 'annotator' in roles
      trader: 'trader' in roles
      querier: 'querier' in roles
      group_querier: 'group-querier' in roles
    rights:
      list_samples: 'admin' in roles
      add_sample: 'importer' in roles or 'admin' in roles
      list_data_sources: 'admin' in roles
      add_data_source: true
      list_annotations: 'admin' in roles
      # TODO: 'trader' in roles or 'annotator' in roles or 'admin' in roles
      add_annotation: true
      add_group: 'admin' in roles
      list_users: 'admin' in roles
      add_user: 'admin' in roles
      query: 'admin' in roles or ('annotator' in roles and 'querier' in roles)
      group_query: 'admin' in roles or ('annotator' in roles and (
        'querier' in roles or 'group-querier' in roles))
      global_query: 'admin' in roles or 'annotator' in roles
      # TODO: We ignored traders. They should be able to add an annotation
      # (the original data source might be theirs), but not do lookups.

  # Render a template.
  @helper 'render', (name, data={}) ->
    data.query_by_transcript = config.MY_GENE_INFO?
    data.base = config.BASE
    data.path = @path
    data.auth = createAuth()
    # https://github.com/altano/handlebars-loader/issues/81
    # As a workaround we use inline partials for now.
    require('../templates/' + name + '.hb') data

  # Showing messages.
  @helper 'info', (message) -> @message 'info', message
  @helper 'success', (message) -> @message 'success', message
  @helper 'error', (message) -> @message 'error', message
  @helper 'message', (type, text) ->
    $('#messages').append @render 'message', type: type, text: text
    currentMessages = $('#messages > div.alert')
    window.setTimeout (-> currentMessages.alert 'close'), 3000

  # Show main page content.
  @helper 'show', (page, data={}) ->
    data.page = page
    if data.pagination?
      {total, current} = data.pagination
      data.pagination = createPagination total, current
    @swap @render page, data
    $('#navigation').html @render 'navigation', data

  # Show picker.
  @helper 'picker', (page, data={}) ->
    if data.pagination?
      {total, current} = data.pagination
      data.pagination = createPagination total, current
    $('#picker .modal-body').html @render "picker_#{page}", data
    $('#picker').modal()

  # Show transcript query results.
  @helper 'transcript_query', (data={}) ->
    $('#transcript-query').html @render 'transcript_query', data

  # Sample picker.
  @get '/picker/samples', ->
    @app.api.samples
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @picker 'samples',
          samples: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Data source picker.
  @get '/picker/data_sources', ->
    @app.api.data_sources
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @picker 'data_sources',
          data_sources: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Group picker.
  @get '/picker/groups', ->
    @app.api.groups
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @picker 'groups',
          groups: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Transcript picker.
  @get '/picker/transcripts', ->
    @picker 'transcripts'
    $('#picker .transcript-querier').focus()

  # Transcript query results.
  @get '/transcript_query', ->
    if @params.query?.length < 1
      @transcript_query()
      return
    $.ajax '//mygene.info/v2/query',
      dataType: 'json'
      data:
        q: @params.query
        # This limits the number of genes, which in turn may have any number
        # of transcripts. So this doesn't actually correspond to the number of
        # entries displayed but it'll do for now. For the same reason, we
        # can't use pagination here.
        limit: config.PAGE_SIZE
        fields: "entrezgene,name,symbol,refseq.rna,#{ config.MY_GENE_INFO.exons_field }"
        species: config.MY_GENE_INFO.species
        entrezonly: true
        dotfield: false
        email: config.MY_GENE_INFO.email
      success: (data) =>
        if data.error
          console.log "MyGene.info query failed: #{ @params.query }"
          @transcript_query()
          return
        transcripts = []
        for hit in data.hits
          continue unless hit.refseq?
          rna = hit.refseq.rna
          rna = [rna] unless Array.isArray rna
          for refseq in rna
            if refseq of (hit[config.MY_GENE_INFO.exons_field] || [])
              transcripts.push
                entrezgene: hit.entrezgene
                symbol: hit.symbol
                name: hit.name
                refseq: refseq
        @transcript_query
          transcripts: transcripts
          # It could be that all hits outide the requested limit (see above)
          # fail our filters. In that case the results displayed are actually
          # complete, but this is the best we can easily do.
          incomplete: data.hits.length < data.total
      error: (xhr) =>
        console.log "MyGene.info query failed: #{ @params.query }"
        console.log xhr.responseText
        @transcript_query()

  # Homepage.
  @get '/', ->
    @show 'home'

  # Authenticate.
  @post '/authenticate', ->
    $('#form-authenticate').removeClass 'success fail'
    updateWith = (result) =>
      $('#form-authenticate').addClass result
      @app.refresh()
    @app.api.authenticate @params['login'], @params['password'],
      success: -> updateWith 'success'
      error: (code, message) =>
        updateWith 'fail'
        @error message
    return

  # List annotations.
  @get '/annotations', ->
    @app.api.annotations
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @show 'annotations',
          subpage: 'list'
          annotations: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Show annotation.
  @get '/annotations/:annotation', ->
    @app.api.annotation @params.annotation,
      success: (annotation) =>
        @show 'annotation',
          subpage: 'show'
          annotation: annotation
      error: (code, message) => @error message

  # Add annotation form.
  @get '/annotations_add', ->
    @show 'annotations', subpage: 'add'

  # Add annotation.
  @post '/annotations', ->
    query = switch @params.query
      when 'sample' then "sample: #{ @params.sample }"
      when 'group' then "group: #{ @params.group }"
      when 'custom' then @params.custom
      else '*'
    @app.api.create_annotation
      name: @params.name
      data_source: @params.data_source
      query: query
      success: (annotation) =>
        @redirect config.BASE, 'annotations', encodeURIComponent annotation.uri
        @success "Added annotation '#{@params.name}'"
      error: (code, message) => @error message
    return

  # List data sources.
  @get '/data_sources', ->
    @app.api.data_sources
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @show 'data_sources',
          subpage: 'list'
          data_sources: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Show data source.
  @get '/data_sources/:data_source', ->
    @app.api.data_source @params.data_source,
      success: (data_source) =>
        @show 'data_source',
          subpage: 'show'
          data_source: data_source
      error: (code, message) => @error message

  # Edit data source form.
  @get '/data_sources/:data_source/edit', ->
    @app.api.data_source @params.data_source,
      success: (data_source) =>
        @show 'data_source',
          subpage: 'edit'
          data_source: data_source
      error: (code, message) => @error message

  # Edit data source.
  @post '/data_sources/:data_source/edit', ->
    unless @params.dirty
      @error 'Data source is unchanged'
      return
    params = {}
    for field in @params.dirty.split ','
      params[field] = @params[field]
    @app.api.edit_data_source @params.data_source,
      data: params
      success: (data_source) =>
        @redirect config.BASE, 'data_sources', encodeURIComponent data_source.uri
        @success "Saved data source '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Delete data_source form.
  @get '/data_sources/:data_source/delete', ->
    @app.api.data_source @params.data_source,
      success: (data_source) =>
        @show 'data_source',
          subpage: 'delete'
          data_source: data_source
      error: (code, message) => @error message

  # Delete data source.
  @post '/data_sources/:data_source/delete', ->
    @app.api.delete_data_source @params.data_source,
      success: =>
        @redirect config.BASE, 'data_sources'
        @success "Deleted data source '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Add data source form.
  @get '/data_sources_add', ->
    @show 'data_sources', subpage: 'add'

  # Add data source.
  @post '/data_sources', ->
    @app.api.create_data_source
      data:
        name: @params.name
        filetype: @params.filetype
        local_path: @params.local_path
      success: (data_source) =>
        @redirect config.BASE, 'data_sources', encodeURIComponent data_source.uri
        @success "Added data source '#{@params.name}'"
      error: (code, message) => @error message
    return

  # List groups.
  @get '/groups', ->
    @app.api.groups
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @show 'groups',
          subpage: 'list'
          groups: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Show group.
  @get '/groups/:group', ->
    @app.api.group @params.group,
      success: (group) =>
        @show 'group',
          subpage: 'show'
          group: group
      error: (code, message) => @error message

  # Edit group form.
  @get '/groups/:group/edit', ->
    @app.api.group @params.group,
      success: (group) =>
        @show 'group',
          subpage: 'edit'
          group: group
      error: (code, message) => @error message

  # Edit group.
  @post '/groups/:group/edit', ->
    unless @params.dirty
      @error 'Group is unchanged'
      return
    params = {}
    for field in @params.dirty.split ','
      params[field] = @params[field]
    @app.api.edit_group @params.group,
      data: params
      success: (group) =>
        @redirect config.BASE, 'groups', encodeURIComponent group.uri
        @success "Saved group '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Delete group form.
  @get '/groups/:group/delete', ->
    @app.api.group @params.group,
      success: (group) =>
        @show 'group',
          subpage: 'delete'
          group: group
      error: (code, message) => @error message

  # Delete group.
  @post '/groups/:group/delete', ->
    @app.api.delete_group @params.group,
      success: =>
        @redirect config.BASE, 'groups'
        @success "Deleted group '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Add group form.
  @get '/groups_add', ->
    @show 'groups', subpage: 'add'

  # Add group.
  @post '/groups', ->
    @app.api.create_group
      data:
        name: @params.name
      success: (group) =>
        @redirect config.BASE, 'groups', encodeURIComponent group.uri
        @success "Added group '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Group samples.
  @get '/groups/:group/samples', ->
    @app.api.group @params.group,
      success: (group) =>
        @app.api.samples
          group: @params.group
          page_number: parseInt @params.page ? 0
          success: (items, pagination) =>
            @show 'group',
              subpage: 'samples'
              group: group
              samples: items
              pagination: pagination
          error: (code, message) => @error message
      error: (code, message) => @error message

  # Lookup variant form.
  @get '/lookup_variant', ->
    @app.api.genome
      success: (genome) =>
        @show 'lookup',
          subpage: 'variant'
          chromosomes: genome.chromosomes
      error: (code, message) => @error message

  # Lookup variant.
  @post '/lookup_variant', ->
    @app.api.create_variant
      data:
        chromosome: @params.chromosome
        position: @params.position
        reference: @params.reference
        observed: @params.observed
      success: (variant) =>
        location = encodeURIComponent variant.uri
        location += "?query=#{ encodeURIComponent @params.query }"
        location += "&sample=#{ encodeURIComponent @params.sample }"
        location += "&group=#{ encodeURIComponent @params.group }"
        location += "&custom=#{ encodeURIComponent @params.custom }"
        @redirect config.BASE, 'variants', location
      error: (code, message) => @error message
    return

  # Lookup variants by region form.
  @get '/lookup_region', ->
    @app.api.genome
      success: (genome) =>
        @show 'lookup',
          subpage: 'region'
          chromosomes: genome.chromosomes
      error: (code, message) => @error message

  # Lookup variants by transcript form.
  @get '/lookup_transcript', ->
    @show 'lookup', subpage: 'transcript'

  # List samples.
  @get '/samples', ->
    @app.api.samples
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @show 'samples',
          subpage: 'list'
          samples: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Add sample form.
  @get '/samples_add', ->
    @show 'samples', subpage: 'add'

  # Add sample.
  @post '/samples', ->
    @app.api.create_sample
      data:
        name: @params.name
        pool_size: @params.pool_size
        coverage_profile: @params.coverage_profile?
        public: @params.public?
      success: (sample) =>
        @redirect config.BASE, 'samples', encodeURIComponent sample.uri
        @success "Added sample '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Show sample.
  @get '/samples/:sample', ->
    @app.api.sample @params.sample,
      success: (sample) =>
        @show 'sample',
          subpage: 'show'
          sample: sample
      error: (code, message) => @error message

  # Edit sample form.
  @get '/samples/:sample/edit', ->
    @app.api.sample @params.sample,
      success: (sample) =>
        @show 'sample',
          subpage: 'edit'
          sample: sample
      error: (code, message) => @error message

  # Edit sample.
  @post '/samples/:sample/edit', ->
    unless @params.dirty
      @error 'Sample is unchanged'
      return
    params = {}
    for field in @params.dirty.split ','
      if field is 'groups'
        if @params[field]?.join?
          value = @params[field].join ','
        else
          value = @params[field] ? ''
      else if field in ['coverage_profile', 'public']
        value = @params[field]?
      else
        value = @params[field]
      params[field] = value
    @app.api.edit_sample @params.sample,
      data: params
      success: (sample) =>
        @redirect config.BASE, 'samples', encodeURIComponent sample.uri
        @success "Saved sample '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Delete sample form.
  @get '/samples/:sample/delete', ->
    @app.api.sample @params.sample,
      success: (sample) =>
        @show 'sample',
          subpage: 'delete'
          sample: sample
      error: (code, message) => @error message

  # Delete sample.
  @post '/samples/:sample/delete', ->
    @app.api.delete_sample @params.sample,
      success: =>
        # Todo: Redirect page might be forbidden for this user.
        @redirect config.BASE, 'samples'
        @success "Deleted sample '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Sample variations.
  @get '/samples/:sample/variations', ->
    @app.api.sample @params.sample,
      success: (sample) =>
        @app.api.variations
          sample: @params.sample
          page_number: parseInt @params.page ? 0
          success: (items, pagination) =>
            @show 'sample',
              subpage: 'variations'
              sample: sample
              variations: items
              pagination: pagination
          error: (code, message) => @error message
      error: (code, message) => @error message

  # Sample coverages.
  @get '/samples/:sample/coverages', ->
    @app.api.sample @params.sample,
      success: (sample) =>
        @app.api.coverages
          sample: @params.sample
          page_number: parseInt @params.page ? 0
          success: (items, pagination) =>
            @show 'sample',
              subpage: 'coverages'
              sample: sample
              coverages: items
              pagination: pagination
          error: (code, message) => @error message
      error: (code, message) => @error message

  # List tokens.
  @get '/tokens', ->
    unless @app.api.current_user?
      @error 'Cannot list API tokens if not authenticated'
      return
    @app.api.tokens
      filter: 'own'
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @show 'tokens',
          subpage: 'list'
          tokens: items
          pagination: pagination
      error: (code, message) => @error message

  # Add token form.
  @get '/tokens_add', ->
    @show 'tokens', subpage: 'add'

  # Add token.
  @post '/tokens', ->
    unless @app.api.current_user?
      @error 'Cannot generate API tokens if not authenticated'
      return
    @app.api.create_token
      data:
        user: @app.api.current_user.uri
        name: @params.name
      success: (token) =>
        @redirect config.BASE, 'tokens', encodeURIComponent token.uri
        @success "Generated API token '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Show token.
  @get '/tokens/:token', ->
    @app.api.token @params.token,
      success: (token) =>
        @show 'token',
          subpage: 'show'
          token: token
      error: (code, message) => @error message

  # Edit token form.
  @get '/tokens/:token/edit', ->
    @app.api.token @params.token,
      success: (token) =>
        @show 'token',
          subpage: 'edit'
          token: token
      error: (code, message) => @error message

  # Edit token.
  @post '/tokens/:token/edit', ->
    unless @params.dirty
      @error 'API token is unchanged'
      return
    params = {}
    for field in @params.dirty.split ','
      params[field] = @params[field]
    @app.api.edit_token @params.token,
      data: params
      success: (token) =>
        @redirect config.BASE, 'tokens', encodeURIComponent token.uri
        @success "Saved API token '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Delete token form.
  @get '/tokens/:token/delete', ->
    @app.api.token @params.token,
      success: (token) =>
        @show 'token',
          subpage: 'delete'
          token: token
      error: (code, message) => @error message

  # Delete token.
  @post '/tokens/:token/delete', ->
    @app.api.delete_token @params.token,
      success: =>
        @redirect config.BASE, 'tokens'
        @success "Revoked API token '#{@params.name}'"
      error: (code, message) => @error message
    return

  # List users.
  @get '/users', ->
    @app.api.users
      filter: @params.filter
      page_number: parseInt @params.page ? 0
      success: (items, pagination) =>
        @show 'users',
          subpage: 'list'
          users: items
          filter: @params.filter ? ''
          pagination: pagination
      error: (code, message) => @error message

  # Show user.
  @get '/users/:user', ->
    @app.api.user @params.user,
      success: (user) =>
        @show 'user',
          subpage: 'show'
          user: user
      error: (code, message) => @error message

  # Edit user form.
  @get '/users/:user/edit', ->
    @app.api.user @params.user,
      success: (user) =>
        user.roles =
          admin: 'admin' in user.roles
          importer: 'importer' in user.roles
          annotator: 'annotator' in user.roles
          trader: 'trader' in user.roles
          querier: 'querier' in user.roles
          group_querier: 'group-querier' in user.roles
        @show 'user',
          subpage: 'edit'
          user: user
      error: (code, message) => @error message

  # Edit user.
  @post '/users/:user/edit', ->
    unless @params.dirty
      @error 'User is unchanged'
      return
    if @params.password isnt @params.password_check
      @error "Password repeat doesn't match"
      return
    params = {}
    for field in @params.dirty.split ','
      if field is 'password_check'
        continue
      if field is 'roles'
        if @params[field]?.join?
          params[field] = @params[field].join ','
        else
          params[field] = @params[field] ? ''
      else
        params[field] = @params[field]
    @app.api.edit_user @params.user,
      data: params
      success: (user) =>
        @redirect config.BASE, 'users', encodeURIComponent user.uri
        @success "Saved user '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Delete user form.
  @get '/users/:user/delete', ->
    @app.api.user @params.user,
      success: (user) =>
        @show 'user',
          subpage: 'delete'
          user: user
      error: (code, message) => @error message

  # Delete user.
  @post '/users/:user/delete', ->
    @app.api.delete_user @params.user,
      success: =>
        @redirect config.BASE, 'users'
        @success "Deleted user '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Add user form.
  @get '/users_add', ->
    @show 'users', subpage: 'add'

  # Add user.
  @post '/users', ->
    if @params.password isnt @params.password_check
      @error "Password repeat doesn't match"
      return
    if @params.roles?.join?
      roles = @params.roles.join ','
    else
      roles = @params.roles ? ''
    @app.api.create_user
      data:
        name: @params.name
        login: @params.login
        password: @params.password
        roles: roles
        email: @params.email
      success: (user) =>
        @redirect config.BASE, 'users', encodeURIComponent user.uri
        @success "Added user '#{@params.name}'"
      error: (code, message) => @error message
    return

  # Show variant.
  @get '/variants/:variant', ->
    query = switch @params.query
      when 'sample' then "sample: #{ @params.sample }"
      when 'group' then "group: #{ @params.group }"
      when 'custom' then @params.custom
      else '*'
    @app.api.variant @params.variant,
      query: query
      success: (variant) =>
        params =
          variant: variant
          query: @params.query
          sample: {uri: @params.sample}
          group: {uri: @params.group}
          custom: @params.custom
        # TODO: The nesting of API calls is quite ugly.
        switch @params.query
          when 'sample' then @app.api.sample @params.sample,
            success: (sample) =>
              params.sample = sample
              @show 'variant', params
            error: (code, message) => @error message
          when 'group' then @app.api.group @params.group,
            success: (group) =>
              params.group = group
              @show 'variant', params
            error: (code, message) => @error message
          else @show 'variant', params
      error: (code, message) => @error message

  # List variants.
  @get '/variants', ->
    # TODO: Our API methods don't return promises, so we promisify some of
    # them here. After promisification of our API this will be obsolete.
    getVariants = (options={}) => new Promise (resolve, reject) =>
      options.success = (items, pagination) -> resolve
        items: items
        pagination: pagination
      options.error = (code, message) -> reject
        code: code
        message: message
      @app.api.variants options

    getSample = (uri, options={}) => new Promise (resolve, reject) =>
      options.success = resolve
      options.error = (code, message) -> reject
        code: code
        message: message
      @app.api.sample uri, options

    getGroup = (uri, options={}) => Promise (resolve, reject) =>
      options.success = resolve
      options.error = (code, message) -> reject
        code: code
        message: message
      @app.api.group uri, options

    # Query mygene.info to construct a region from the transcript (which is
    # given as <entrezgene>/<refseq>).
    getTranscriptRegion = (transcript) ->
      [entrezgene, refseq] = transcript.split '/'
      Promise.resolve $.ajax "//mygene.info/v2/gene/#{ entrezgene }",
        dataType: 'json'
        data:
          fields: config.MY_GENE_INFO.exons_field
          email: config.MY_GENE_INFO.email
      .then (data) ->
        coordinates = data[config.MY_GENE_INFO.exons_field][refseq]
        chromosome: coordinates.chr
        begin: coordinates.txstart
        end: coordinates.txend
      .catch ->
        throw new Error "Could not retrieve annotation for transcript #{ refseq }"

    # The region to query is defined either directly, or as a transcript in
    # the form <entrezgene>/<refseq>. We can query mygene.info to convert the
    # transcript into a region.
    getRegion =
      if @params.transcript
        # TODO: Optionally only look at exons of a transcript. This can be
        # implemented by changing the API to accept a list of regions, or by
        # removing the intronic variants here manually. Preferably the former.
        getTranscriptRegion @params.transcript
      else
        # Synchronous promise, we already have the region.
        Promise.resolve
          chromosome: @params.chromosome
          begin: @params.begin
          end: @params.end

    # We need the region before we can get the variants. Both are needed
    # later.
    getRegionAndVariants = getRegion.then (region) =>
      getVariants
        query: switch @params.query
          when 'sample' then "sample: #{ @params.sample }"
          when 'group' then "group: #{ @params.group }"
          when 'custom' then @params.custom
          else '*'
        region: region
        page_number: parseInt @params.page ? 0
      .then (result) -> [region, result]

    # If querying on sample, get the sample data (name, etc). Likewise if we
    # are querying on group.
    getQueryParam =
      switch @params.query
        when 'sample' then (getSample @params.sample).then (sample) ->
          ['sample', sample]
        when 'group' then (getGroup @params.group).then (group) ->
          ['group', group]
        else Promise.resolve ['custom', @params.custom]

    Promise.all [getQueryParam, getRegionAndVariants]
    .then ([[param, value], [region, result]]) =>
      data =
        query: @params.query
        region: region
        variants: result.items
        pagination: result.pagination
      data[param] = value
      # TODO: For a lookup by transcript, it might be nice to show some more
      # information on that such as gene name, transcript accession, and
      # perhaps even map the variant positions to the transcript.
      @show 'variants', data
    .catch (error) =>
      # TODO: Use our own Error type and only show errors of that type
      # directly in the user interface.
      @error error.message


module.exports = app
