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
URI = require 'urijs'

config = require 'config'
{ApiError} = require './api'


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

  # Redirect to some location.
  @helper 'goto', (base, segments=[], query={}) ->
    # The Sammy.js @redirect is not good enough because it doesn't resolve to
    # a base URI (it just joins all arguments with '/'), so we wrap it with
    # our own URI builder.
    uri = segments
      .reduce ((uri, segment) -> uri.segmentCoded segment), URI base
      .setQuery query
      .toString()
    @redirect uri
    # It is useful to not return undefined here so we can easily have this as
    # last expression in a promise handler without raising a Bluebird warning.
    # http://bluebirdjs.com/docs/warning-explanations.html#warning-a-promise-was-created-in-a-handler-but-none-were-returned-from-it
    null

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
    .then ({items, pagination}) =>
      @picker 'samples',
        samples: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Data source picker.
  @get '/picker/data_sources', ->
    @app.api.data_sources
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @picker 'data_sources',
        data_sources: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Group picker.
  @get '/picker/groups', ->
    @app.api.groups
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @picker 'groups',
        groups: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Transcript picker.
  @get '/picker/transcripts', ->
    @picker 'transcripts'
    $('#picker .transcript-querier').focus()

  # Transcript query results.
  @get '/transcript_query', ->
    if @params.query?.length < 1
      @transcript_query()
      return
    Promise.resolve $.ajax '//mygene.info/v2/query',
      dataType: 'json'
      data:
        q: @params.query
        # This limits the number of genes, which in turn may have any number
        # of transcripts. So this doesn't actually correspond to the number of
        # entries displayed but it'll do for now. For the same reason, we
        # can't use pagination here.
        limit: config.PAGE_SIZE
        fields: 'entrezgene,name,symbol,refseq.rna,' +
                config.MY_GENE_INFO.exons_field
        species: config.MY_GENE_INFO.species
        entrezonly: true
        dotfield: false
        email: config.MY_GENE_INFO.email
    .then (data) =>
      if data.error
        console.log "MyGene.info query failed: #{ @params.query }"
        @transcript_query()
        throw new ApiError 'mygeneinfo_error',
          "MyGene.info query failed: #{ @params.query }"
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
    .catch (xhr) =>
      console.log "MyGene.info query failed: #{ @params.query }"
      console.log xhr.responseText
      @transcript_query()
      throw new ApiError 'mygeneinfo_error',
        "MyGene.info query failed: #{ @params.query }"

  # Authenticate.
  @post '/authenticate', ->
    $('#form-authenticate').removeClass 'success fail'
    updateWith = (result) =>
      $('#form-authenticate').addClass result
      @app.refresh()
    @app.api.authenticate @params['login'], @params['password']
    .then -> updateWith 'success'
    .catch ApiError, ({message}) =>
      updateWith 'fail'
      @error message
    return

  # List annotations.
  @get '/annotations', ->
    @app.api.annotations
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @show 'annotations',
        subpage: 'list'
        annotations: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Show annotation.
  @get '/annotations/:annotation', ->
    @app.api.annotation @params.annotation
    .then (annotation) =>
      @show 'annotation',
        subpage: 'show'
        annotation: annotation
    .catch ApiError, ({message}) => @error message

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
    .then (annotation) =>
      @goto config.BASE, ['annotations', annotation.uri]
      @success "Added annotation '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # List data sources.
  @get '/data_sources', ->
    @app.api.data_sources
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @show 'data_sources',
        subpage: 'list'
        data_sources: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Show data source.
  @get '/data_sources/:data_source', ->
    @app.api.data_source @params.data_source
    .then (data_source) =>
      @show 'data_source',
        subpage: 'show'
        data_source: data_source
    .catch ApiError, ({message}) => @error message

  # Edit data source form.
  @get '/data_sources/:data_source/edit', ->
    @app.api.data_source @params.data_source
    .then (data_source) =>
      @show 'data_source',
        subpage: 'edit'
        data_source: data_source
    .catch ApiError, ({message}) => @error message

  # Edit data source.
  @post '/data_sources/:data_source/edit', ->
    unless @params.dirty
      @error 'Data source is unchanged'
      return
    data = {}
    for field in @params.dirty.split ','
      data[field] = @params[field]
    @app.api.edit_data_source @params.data_source, data
    .then (data_source) =>
      @goto config.BASE, ['data_sources', data_source.uri]
      @success "Saved data source '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Delete data_source form.
  @get '/data_sources/:data_source/delete', ->
    @app.api.data_source @params.data_source
    .then (data_source) =>
      @show 'data_source',
        subpage: 'delete'
        data_source: data_source
    .catch ApiError, ({message}) => @error message

  # Delete data source.
  @post '/data_sources/:data_source/delete', ->
    @app.api.delete_data_source @params.data_source
    .then =>
      @goto config.BASE, ['data_sources']
      @success "Deleted data source '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Add data source form.
  @get '/data_sources_add', ->
    @show 'data_sources', subpage: 'add'

  # Add data source.
  @post '/data_sources', ->
    @app.api.create_data_source
      name: @params.name
      filetype: @params.filetype
      local_path: @params.local_path
    .then (data_source) =>
      @goto config.BASE, ['data_sources', data_source.uri]
      @success "Added data source '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # List groups.
  @get '/groups', ->
    @app.api.groups
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @show 'groups',
        subpage: 'list'
        groups: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Show group.
  @get '/groups/:group', ->
    @app.api.group @params.group
    .then (group) =>
      @show 'group',
        subpage: 'show'
        group: group
    .catch ApiError, ({message}) => @error message

  # Edit group form.
  @get '/groups/:group/edit', ->
    @app.api.group @params.group
    .then (group) =>
      @show 'group',
        subpage: 'edit'
        group: group
    .catch ApiError, ({message}) => @error message

  # Edit group.
  @post '/groups/:group/edit', ->
    unless @params.dirty
      @error 'Group is unchanged'
      return
    data = {}
    for field in @params.dirty.split ','
      data[field] = @params[field]
    @app.api.edit_group @params.group, data
    .then (group) =>
      @goto config.BASE, ['groups', group.uri]
      @success "Saved group '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Delete group form.
  @get '/groups/:group/delete', ->
    @app.api.group @params.group
    .then (group) =>
      @show 'group',
        subpage: 'delete'
        group: group
    .catch ApiError, ({message}) => @error message

  # Delete group.
  @post '/groups/:group/delete', ->
    @app.api.delete_group @params.group
    .then =>
      @goto config.BASE, ['groups']
      @success "Deleted group '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Add group form.
  @get '/groups_add', ->
    @show 'groups', subpage: 'add'

  # Add group.
  @post '/groups', ->
    @app.api.create_group
      name: @params.name
    .then (group) =>
      @goto config.BASE, ['groups', group.uri]
      @success "Added group '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Group samples.
  @get '/groups/:group/samples', ->
    getGroup = @app.api.group @params.group
    getSamples = @app.api.samples
      group: @params.group
      page_number: parseInt @params.page ? 0
    Promise.join getGroup, getSamples, (group, {items, pagination}) =>
      @show 'group',
        subpage: 'samples'
        group: group
        samples: items
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Lookup variant form.
  @get '/lookup_variant', ->
    @app.api.genome()
    .then (genome) =>
      @show 'lookup',
        subpage: 'variant'
        chromosomes: genome.chromosomes
    .catch ApiError, ({message}) => @error message

  # Lookup variant.
  @post '/lookup_variant', ->
    @app.api.create_variant
      chromosome: @params.chromosome
      position: @params.position
      reference: @params.reference
      observed: @params.observed
    .then (variant) =>
      @goto config.BASE, ['variants', variant.uri],
        query: @params.query
        sample: @params.sample
        group: @params.group
        custom: @params.custom
    .catch ApiError, ({message}) => @error message
    return

  # Lookup variants by region form.
  @get '/lookup_region', ->
    @app.api.genome()
    .then (genome) =>
      @show 'lookup',
        subpage: 'region'
        chromosomes: genome.chromosomes
    .catch ApiError, ({message}) => @error message

  # Lookup variants by transcript form.
  @get '/lookup_transcript', ->
    @show 'lookup', subpage: 'transcript'

  # List samples.
  @get '/samples', ->
    @app.api.samples
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @show 'samples',
        subpage: 'list'
        samples: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Add sample form.
  @get '/samples_add', ->
    @show 'samples', subpage: 'add'

  # Add sample.
  @post '/samples', ->
    @app.api.create_sample
      name: @params.name
      pool_size: @params.pool_size
      coverage_profile: @params.coverage_profile?
      public: @params.public?
    .then (sample) =>
      @goto config.BASE, ['samples', sample.uri]
      @success "Added sample '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Show sample.
  @get '/samples/:sample', ->
    @app.api.sample @params.sample
    .then (sample) =>
      @show 'sample',
        subpage: 'show'
        sample: sample
    .catch ApiError, ({message}) => @error message

  # Edit sample form.
  @get '/samples/:sample/edit', ->
    @app.api.sample @params.sample
    .then (sample) =>
      @show 'sample',
        subpage: 'edit'
        sample: sample
    .catch ApiError, ({message}) => @error message

  # Edit sample.
  @post '/samples/:sample/edit', ->
    unless @params.dirty
      @error 'Sample is unchanged'
      return
    data = {}
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
      data[field] = value
    @app.api.edit_sample @params.sample, data
    .then (sample) =>
      @goto config.BASE, ['samples', sample.uri]
      @success "Saved sample '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Delete sample form.
  @get '/samples/:sample/delete', ->
    @app.api.sample @params.sample
    .then (sample) =>
      @show 'sample',
        subpage: 'delete'
        sample: sample
    .catch ApiError, ({message}) => @error message

  # Delete sample.
  @post '/samples/:sample/delete', ->
    @app.api.delete_sample @params.sample
    .then =>
      # Todo: Redirect page might be forbidden for this user.
      @goto config.BASE, ['samples']
      @success "Deleted sample '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Sample variations.
  @get '/samples/:sample/variations', ->
    getSample = @app.api.sample @params.sample
    getVariations = @app.api.variations
      sample: @params.sample
      page_number: parseInt @params.page ? 0
    Promise.join getSample, getVariations, (sample, {items, pagination}) =>
      @show 'sample',
        subpage: 'variations'
        sample: sample
        variations: items
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Sample coverages.
  @get '/samples/:sample/coverages', ->
    getSample = @app.api.sample @params.sample
    getCoverages = @app.api.coverages
      sample: @params.sample
      page_number: parseInt @params.page ? 0
    Promise.join getSample, getCoverages, (sample, {items, pagination}) =>
      @show 'sample',
        subpage: 'coverages'
        sample: sample
        coverages: items
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # List tokens.
  @get '/tokens', ->
    unless @app.api.current_user?
      @error 'Cannot list API tokens if not authenticated'
      return
    @app.api.tokens
      filter: 'own'
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @show 'tokens',
        subpage: 'list'
        tokens: items
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Add token form.
  @get '/tokens_add', ->
    @show 'tokens', subpage: 'add'

  # Add token.
  @post '/tokens', ->
    unless @app.api.current_user?
      @error 'Cannot generate API tokens if not authenticated'
      return
    @app.api.create_token
      user: @app.api.current_user.uri
      name: @params.name
    .then (token) =>
      @goto config.BASE, ['tokens', token.uri]
      @success "Generated API token '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Show token.
  @get '/tokens/:token', ->
    @app.api.token @params.token
    .then (token) =>
      @show 'token',
        subpage: 'show'
        token: token
    .catch ApiError, ({message}) => @error message

  # Edit token form.
  @get '/tokens/:token/edit', ->
    @app.api.token @params.token
    .then (token) =>
      @show 'token',
        subpage: 'edit'
        token: token
    .catch ApiError, ({message}) => @error message

  # Edit token.
  @post '/tokens/:token/edit', ->
    unless @params.dirty
      @error 'API token is unchanged'
      return
    data = {}
    for field in @params.dirty.split ','
      data[field] = @params[field]
    @app.api.edit_token @params.token, data
    .then (token) =>
      @goto config.BASE, ['tokens', token.uri]
      @success "Saved API token '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Delete token form.
  @get '/tokens/:token/delete', ->
    @app.api.token @params.token
    .then (token) =>
      @show 'token',
        subpage: 'delete'
        token: token
    .catch ApiError, ({message}) => @error message

  # Delete token.
  @post '/tokens/:token/delete', ->
    @app.api.delete_token @params.token
    .then =>
      @goto config.BASE, ['tokens']
      @success "Revoked API token '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # List users.
  @get '/users', ->
    @app.api.users
      filter: @params.filter
      page_number: parseInt @params.page ? 0
    .then ({items, pagination}) =>
      @show 'users',
        subpage: 'list'
        users: items
        filter: @params.filter ? ''
        pagination: pagination
    .catch ApiError, ({message}) => @error message

  # Show user.
  @get '/users/:user', ->
    @app.api.user @params.user
    .then (user) =>
      @show 'user',
        subpage: 'show'
        user: user
    .catch ApiError, ({message}) => @error message

  # Edit user form.
  @get '/users/:user/edit', ->
    @app.api.user @params.user
    .then (user) =>
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
    .catch ApiError, ({message}) => @error message

  # Edit user.
  @post '/users/:user/edit', ->
    unless @params.dirty
      @error 'User is unchanged'
      return
    if @params.password isnt @params.password_check
      @error "Password repeat doesn't match"
      return
    data = {}
    for field in @params.dirty.split ','
      if field is 'password_check'
        continue
      if field is 'roles'
        if @params[field]?.join?
          data[field] = @params[field].join ','
        else
          data[field] = @params[field] ? ''
      else
        data[field] = @params[field]
    @app.api.edit_user @params.user, data
    .then (user) =>
      @goto config.BASE, ['users', user.uri]
      @success "Saved user '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Delete user form.
  @get '/users/:user/delete', ->
    @app.api.user @params.user
    .then (user) =>
      @show 'user',
        subpage: 'delete'
        user: user
    .catch ApiError, ({message}) => @error message

  # Delete user.
  @post '/users/:user/delete', ->
    @app.api.delete_user @params.user
    .then =>
      @goto config.BASE, ['users']
      @success "Deleted user '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
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
      name: @params.name
      login: @params.login
      password: @params.password
      roles: roles
      email: @params.email
    .then (user) =>
      @goto config.BASE, ['users', user.uri]
      @success "Added user '#{@params.name}'"
    .catch ApiError, ({message}) => @error message
    return

  # Show variant.
  @get '/variants/:variant', ->
    # Get the annotated variant.
    getVariant = @app.api.variant @params.variant, query:
      switch @params.query
        when 'sample' then "sample: #{ @params.sample }"
        when 'group' then "group: #{ @params.group }"
        when 'custom' then @params.custom
        else '*'

    # If querying on sample, get the sample data (name, etc). Likewise if we
    # are querying on group.
    getQueryParam =
      switch @params.query
        when 'sample' then @app.api.sample(@params.sample).then (sample) ->
          ['sample', sample]
        when 'group' then @app.api.group(@params.group).then (group) ->
          ['group', group]
        when 'custom' then Promise.resolve ['custom', @params.custom]
        else Promise.resolve [null, null]

    Promise.join getVariant, getQueryParam, (variant, [param, value]) =>
      data =
        variant: variant
        query: @params.query
        sample: {uri: @params.sample}
        group: {uri: @params.group}
      data[param] = value
      @show 'variant', data
    .catch ApiError, ({message}) => @error message

  # List variants.
  @get '/variants', ->
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
        if data.error
          throw new ApiError 'mygeneinfo_error',
            "Could not retrieve annotation for transcript #{ refseq }"
        coordinates = data[config.MY_GENE_INFO.exons_field][refseq]
        chromosome: coordinates.chr
        begin: coordinates.txstart
        end: coordinates.txend
      .catch (xhr) ->
        console.log 'Unexpected response from MyGene.info'
        console.log xhr.responseText
        throw new ApiError 'mygeneinfo_error',
          "Could not retrieve annotation for transcript #{ refseq }"

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
      @app.api.variants
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
        when 'sample' then @app.api.sample(@params.sample).then (sample) ->
          ['sample', sample]
        when 'group' then @app.api.group(@params.group).then (group) ->
          ['group', group]
        when 'custom' then Promise.resolve ['custom', @params.custom]
        else Promise.resolve [null, null]

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
    .catch ApiError, ({message}) => @error message

  # Homepage.
  # This route acts as a catchall and must be defined last.
  @get '', ->
    @show 'home'


module.exports = app
