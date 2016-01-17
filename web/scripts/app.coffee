# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Todo: Figure out roles and rights for variant lookup.


define ['jquery',
        'bluebird',
        'cs!config',
        'sammy',
        'handlebars',
        'moment',
        'jquery.base64',
        'sammy.handlebars'], ($, Promise, config, Sammy, Handlebars, moment) ->

    Sammy '#main', ->

        # Always call init() with an initialized Api instance before calling
        # run().
        @init = (api) => @api = api

        # Taken from Sammy.js EventContext private method.
        parsePath = (path) ->
            parseParamPair = (params, key, value) ->
                isArray = (obj) -> (Object.prototype.toString.call obj) == "[object Array]"
                if params[key]?
                    if isArray params[key]
                        params[key].push value
                    else
                        params[key] = [params[key], value]
                else
                    params[key] = value
                params
            decode = (str) -> decodeURIComponent (str?.replace /\+/g, ' ') ? ''
            [match, base, query] = (path.match /^([^?]*)\?([^#]*)?$/) ? [false, path, '']
            params = {}
            if match and query
                pairs = query.split '&'
                for p in pairs
                    pair = p.split '='
                    params = parseParamPair params, (decode pair[0]), (decode pair[1] ? '')
            [base, params]

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
            if not @api.current_user? then return null
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
                add_annotation: true #'trader' in roles or 'annotator' in roles or 'admin' in roles
                add_group: 'admin' in roles
                list_users: 'admin' in roles
                add_user: 'admin' in roles
                query: 'admin' in roles or ('annotator' in roles and 'querier' in roles)
                group_query: 'admin' in roles or ('annotator' in roles and ('querier' in roles or 'group-querier' in roles))
                global_query: 'admin' in roles or 'annotator' in roles
                # TODO: We ignored traders. They should be able to add an
                #   annotation (the original data source might be theirs),
                #   but not do lookups.

        # We use Handlebars for templates.
        @use Sammy.Handlebars, 'hb'

        # Some helpers for use in the templates.
        # With inspiration from: https://github.com/raDiesle/Handlebars.js-helpers-collection
        Handlebars.registerHelper 'escape', (value) ->
            encodeURIComponent value
        Handlebars.registerHelper 'if_eq', (context, options) ->
            if context == options.hash.compare
                options.fn @
            else
                options.inverse @
        Handlebars.registerHelper 'title', (options) ->
            $('h1').html options.fn @
            $('title').html 'Aule - ' + options.fn @
            return
        Handlebars.registerHelper 'pickerTitle', (options) ->
            $('#picker .modal-header h3').html options.fn @
            return
        Handlebars.registerHelper 'updatePath', (path, options) ->
            [base, params] = parsePath path
            base + '?' + $.param $.extend params, options.hash
        Handlebars.registerHelper 'dateFormat', (date, options) ->
            moment(date).format options.hash.format ? 'MMM Do, YYYY'
        Handlebars.registerHelper 'numberFormat', (number, options) ->
            number.toFixed options.hash.decimals ? 2
        Handlebars.registerHelper 'commaSeparated', (items, options) ->
            items.join(',')

        # Get location for template.
        @helper 'template', (name) ->
            config.RESOURCES_PREFIX + '/templates/' + name + '.hb'

        # Showing messages.
        @helper 'info', (message) -> @message 'info', message
        @helper 'success', (message) -> @message 'success', message
        @helper 'error', (message) -> @message 'error', message
        @helper 'message', (type, text) ->
            @render((@template 'message'), type: type, text: text)
                .appendTo $('#messages')

        # Show main page content.
        @helper 'show', (page, data={}, options={}) ->
            partials = {}
            data.base = config.RESOURCES_PREFIX
            data.path = @path
            data.page = page
            data.subpage = options.subpage
            data.auth = createAuth()
            if options.subpage?
                partials.subpage = @template "#{page}_#{options.subpage}"
            if options.pagination?
                partials.pagination = @template 'pagination'
                {total, current} = options.pagination
                data.pagination = createPagination total, current
            @partial (@template page), data, partials
            @render((@template 'navigation'), data).replace $('#navigation')

        # Show picker.
        @helper 'picker', (page, data={}, options={}) ->
            partials = {}
            data.base = config.RESOURCES_PREFIX
            data.path = @path
            data.auth = createAuth()
            if options.pagination?
                partials.pagination = @template 'pagination'
                {total, current} = options.pagination
                data.pagination = createPagination total, current
            @render((@template "picker_#{page}"), data, partials).replace $('#picker .modal-body')
            $('#picker').modal()

        # Sample picker.
        @get '/picker/samples', ->
            @app.api.samples
                filter: @params.filter
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @picker 'samples',
                        {samples: items, filter: @params.filter ? ''},
                        {pagination: pagination}
                error: (code, message) => @error message

        # Data source picker.
        @get '/picker/data_sources', ->
            @app.api.data_sources
                filter: @params.filter
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @picker 'data_sources',
                        {data_sources: items, filter: @params.filter ? ''},
                        {pagination: pagination}
                error: (code, message) => @error message

        # Group picker.
        @get '/picker/groups', ->
            @app.api.groups
                filter: @params.filter
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @picker 'groups',
                        {groups: items, filter: @params.filter ? ''},
                        {pagination: pagination}
                error: (code, message) => @error message

        # Index.
        @get '/', ->
            @show 'index'

        # Server info.
        @get '/server', ->
            @server @app.uris.root,
                success: (r) => @show 'server', r

        # Authenticate.
        @post '/authenticate', ->
            $('#form-authenticate').removeClass 'success fail'
            update = (result) =>
                $('#form-authenticate').addClass result
                @app.refresh()
            @app.api.authenticate @params['login'], @params['password'],
                success: => update 'success'
                error: (code, message) =>
                    update 'fail'
                    @error message
            return

        # List annotations.
        @get '/annotations', ->
            @app.api.annotations
                filter: @params.filter
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @show 'annotations',
                        {annotations: items, filter: @params.filter ? ''},
                        {subpage: 'list', pagination: pagination}
                error: (code, message) => @error message

        # Show annotation.
        @get '/annotations/:annotation', ->
            @app.api.annotation @params.annotation,
                success: (annotation) =>
                    @show 'annotation', {annotation: annotation}, {subpage: 'show'}
                error: (code, message) => @error message

        # Add annotation form.
        @get '/annotations_add', ->
            @show 'annotations', {}, {subpage: 'add'}

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
                    location = config.RESOURCES_PREFIX + '/annotations/'
                    location += (encodeURIComponent annotation.uri)
                    @redirect location
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
                        {data_sources: items, filter: @params.filter ? ''},
                        {subpage: 'list', pagination: pagination}
                error: (code, message) => @error message

        # Show data source.
        @get '/data_sources/:data_source', ->
            @app.api.data_source @params.data_source,
                success: (data_source) =>
                    @show 'data_source', {data_source: data_source}, {subpage: 'show'}
                error: (code, message) => @error message

        # Edit data source form.
        @get '/data_sources/:data_source/edit', ->
            @app.api.data_source @params.data_source,
                success: (data_source) =>
                    @show 'data_source', {data_source: data_source}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Edit data source.
        @post '/data_sources/:data_source/edit', ->
            if not @params.dirty
                @error 'Data source is unchanged'
                return
            params = {}
            for field in @params.dirty.split ','
                params[field] = @params[field]
            @app.api.edit_data_source @params.data_source,
                data: params
                success: (data_source) =>
                    location = config.RESOURCES_PREFIX + '/data_sources/'
                    location += (encodeURIComponent data_source.uri)
                    @redirect location
                    @success "Saved data source '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Delete data_source form.
        @get '/data_sources/:data_source/delete', ->
            @app.api.data_source @params.data_source,
                success: (data_source) =>
                    @show 'data_source', {data_source: data_source}, {subpage: 'delete'}
                error: (code, message) => @error message

        # Delete data source.
        @post '/data_sources/:data_source/delete', ->
            @app.api.delete_data_source @params.data_source,
                success: =>
                    @redirect config.RESOURCES_PREFIX + '/data_sources'
                    @success "Deleted data source '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Add data source form.
        @get '/data_sources_add', ->
            @show 'data_sources', {}, {subpage: 'add'}

        # Add data source.
        @post '/data_sources', ->
            @app.api.create_data_source
                data:
                    name: @params.name
                    filetype: @params.filetype
                    local_path: @params.local_path
                success: (data_source) =>
                    location = config.RESOURCES_PREFIX + '/data_sources/'
                    location += (encodeURIComponent data_source.uri)
                    @redirect location
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
                        {groups: items, filter: @params.filter ? ''},
                        {subpage: 'list', pagination: pagination}
                error: (code, message) => @error message

        # Show group.
        @get '/groups/:group', ->
            @app.api.group @params.group,
                success: (group) =>
                    @show 'group', {group: group}, {subpage: 'show'}
                error: (code, message) => @error message

        # Edit group form.
        @get '/groups/:group/edit', ->
            @app.api.group @params.group,
                success: (group) =>
                    @show 'group', {group: group}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Edit group.
        @post '/groups/:group/edit', ->
            if not @params.dirty
                @error 'Group is unchanged'
                return
            params = {}
            for field in @params.dirty.split ','
                params[field] = @params[field]
            @app.api.edit_group @params.group,
                data: params
                success: (group) =>
                    location = config.RESOURCES_PREFIX + '/groups/'
                    location += (encodeURIComponent group.uri)
                    @redirect location
                    @success "Saved group '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Delete group form.
        @get '/groups/:group/delete', ->
            @app.api.group @params.group,
                success: (group) =>
                    @show 'group', {group: group}, {subpage: 'delete'}
                error: (code, message) => @error message

        # Delete group.
        @post '/groups/:group/delete', ->
            @app.api.delete_group @params.group,
                success: =>
                    @redirect config.RESOURCES_PREFIX + '/groups'
                    @success "Deleted group '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Add group form.
        @get '/groups_add', ->
            @show 'groups', {}, {subpage: 'add'}

        # Add group.
        @post '/groups', ->
            @app.api.create_group
                data:
                    name: @params.name
                success: (group) =>
                    location = config.RESOURCES_PREFIX + '/groups/'
                    location += (encodeURIComponent group.uri)
                    @redirect location
                    @success "Added group '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Group samples.
        @get '/groups/:group/samples', ->
            # Todo: Instead of the ugly nesting of these request callbacks, we
            #     should use jQuery deferred objects [1] or a similar pattern.
            # [1] http://api.jquery.com/jQuery.when/
            @app.api.group @params.group,
                success: (group) =>
                    @app.api.samples
                        group: @params.group
                        page_number: parseInt @params.page ? 0
                        success: (items, pagination) =>
                            @show 'group',
                                {group: group, samples: items},
                                {subpage: 'samples', pagination: pagination}
                        error: (code, message) => @error message
                error: (code, message) => @error message

        # Lookup variant form.
        @get '/lookup_variant', ->
            @app.api.genome
                success: (genome) =>
                    @show 'lookup', {chromosomes: genome.chromosomes}, {subpage: 'variant'}
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
                    location = config.RESOURCES_PREFIX + '/variants/'
                    location += (encodeURIComponent variant.uri)
                    location += "?query=#{ encodeURIComponent @params.query }"
                    location += "&sample=#{ encodeURIComponent @params.sample }"
                    location += "&group=#{ encodeURIComponent @params.group }"
                    location += "&custom=#{ encodeURIComponent @params.custom }"
                    @redirect location
                error: (code, message) => @error message
            return

        # Lookup variants form.
        @get '/lookup_region', ->
            @app.api.genome
                success: (genome) =>
                    @show 'lookup', {chromosomes: genome.chromosomes}, {subpage: 'region'}
                error: (code, message) => @error message

        # List samples.
        @get '/samples', ->
            @app.api.samples
                filter: @params.filter
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @show 'samples',
                        {samples: items, filter: @params.filter ? ''},
                        {subpage: 'list', pagination: pagination}
                error: (code, message) => @error message

        # Add sample form.
        @get '/samples_add', ->
            @show 'samples', {}, {subpage: 'add'}

        # Add sample.
        @post '/samples', ->
            @app.api.create_sample
                data:
                    name: @params.name
                    pool_size: @params.pool_size
                    coverage_profile: @params.coverage_profile?
                    public: @params.public?
                success: (sample) =>
                    location = config.RESOURCES_PREFIX + '/samples/'
                    location += (encodeURIComponent sample.uri)
                    @redirect location
                    @success "Added sample '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Show sample.
        @get '/samples/:sample', ->
            @app.api.sample @params.sample,
                success: (sample) =>
                    @show 'sample', {sample: sample}, {subpage: 'show'}
                error: (code, message) => @error message

        # Edit sample form.
        @get '/samples/:sample/edit', ->
            @app.api.sample @params.sample,
                success: (sample) =>
                    @show 'sample', {sample: sample}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Edit sample.
        @post '/samples/:sample/edit', ->
            if not @params.dirty
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
                    location = config.RESOURCES_PREFIX + '/samples/'
                    location += (encodeURIComponent sample.uri)
                    @redirect location
                    @success "Saved sample '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Delete sample form.
        @get '/samples/:sample/delete', ->
            @app.api.sample @params.sample,
                success: (sample) =>
                    @show 'sample', {sample: sample}, {subpage: 'delete'}
                error: (code, message) => @error message

        # Delete sample.
        @post '/samples/:sample/delete', ->
            @app.api.delete_sample @params.sample,
                success: =>
                    # Todo: Redirect page might be forbidden for this user.
                    @redirect config.RESOURCES_PREFIX + '/samples'
                    @success "Deleted sample '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Sample variations.
        @get '/samples/:sample/variations', ->
            # Todo: Instead of the ugly nesting of these request callbacks, we
            #     should use jQuery deferred objects [1] or a similar pattern.
            # [1] http://api.jquery.com/jQuery.when/
            @app.api.sample @params.sample,
                success: (sample) =>
                    @app.api.variations
                        sample: @params.sample
                        page_number: parseInt @params.page ? 0
                        success: (items, pagination) =>
                            @show 'sample',
                                {sample: sample, variations: items},
                                {subpage: 'variations', pagination: pagination}
                        error: (code, message) => @error message
                error: (code, message) => @error message

        # Sample coverages.
        @get '/samples/:sample/coverages', ->
            # Todo: Instead of the ugly nesting of these request callbacks, we
            #     should use jQuery deferred objects [1] or a similar pattern.
            # [1] http://api.jquery.com/jQuery.when/
            @app.api.sample @params.sample,
                success: (sample) =>
                    @app.api.coverages
                        sample: @params.sample
                        page_number: parseInt @params.page ? 0
                        success: (items, pagination) =>
                            @show 'sample',
                                {sample: sample, coverages: items},
                                {subpage: 'coverages', pagination: pagination}
                        error: (code, message) => @error message
                error: (code, message) => @error message

        # List tokens.
        @get '/tokens', ->
            if not @app.api.current_user?
                @error 'Cannot list API tokens if not authenticated'
                return
            @app.api.tokens
                filter: 'own'
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @show 'tokens',
                        {tokens: items},
                        {subpage: 'list', pagination: pagination}
                error: (code, message) => @error message

        # Add token form.
        @get '/tokens_add', ->
            @show 'tokens', {}, {subpage: 'add'}

        # Add token.
        @post '/tokens', ->
            if not @app.api.current_user?
                @error 'Cannot generate API tokens if not authenticated'
                return
            @app.api.create_token
                data:
                    user: @app.api.current_user.uri
                    name: @params.name
                success: (token) =>
                    location = config.RESOURCES_PREFIX + '/tokens/'
                    location += (encodeURIComponent token.uri)
                    @redirect location
                    @success "Generated API token '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Show token.
        @get '/tokens/:token', ->
            @app.api.token @params.token,
                success: (token) =>
                    @show 'token', {token: token}, {subpage: 'show'}
                error: (code, message) => @error message

        # Edit token form.
        @get '/tokens/:token/edit', ->
            @app.api.token @params.token,
                success: (token) =>
                    @show 'token', {token: token}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Edit token.
        @post '/tokens/:token/edit', ->
            if not @params.dirty
                @error 'API token is unchanged'
                return
            params = {}
            for field in @params.dirty.split ','
                params[field] = @params[field]
            @app.api.edit_token @params.token,
                data: params
                success: (token) =>
                    location = config.RESOURCES_PREFIX + '/tokens/'
                    location += (encodeURIComponent token.uri)
                    @redirect location
                    @success "Saved API token '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Delete token form.
        @get '/tokens/:token/delete', ->
            @app.api.token @params.token,
                success: (token) =>
                    @show 'token', {token: token}, {subpage: 'delete'}
                error: (code, message) => @error message

        # Delete token.
        @post '/tokens/:token/delete', ->
            @app.api.delete_token @params.token,
                success: =>
                    @redirect config.RESOURCES_PREFIX + '/tokens'
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
                        {users: items, filter: @params.filter ? ''},
                        {subpage: 'list', pagination: pagination}
                error: (code, message) => @error message

        # Show user.
        @get '/users/:user', ->
            @app.api.user @params.user,
                success: (user) =>
                    @show 'user', {user: user}, {subpage: 'show'}
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
                    @show 'user', {user: user}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Edit user.
        @post '/users/:user/edit', ->
            if not @params.dirty
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
                    location = config.RESOURCES_PREFIX + '/users/'
                    location += (encodeURIComponent user.uri)
                    @redirect location
                    @success "Saved user '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Delete user form.
        @get '/users/:user/delete', ->
            @app.api.user @params.user,
                success: (user) =>
                    @show 'user', {user: user}, {subpage: 'delete'}
                error: (code, message) => @error message

        # Delete user.
        @post '/users/:user/delete', ->
            @app.api.delete_user @params.user,
                success: =>
                    @redirect config.RESOURCES_PREFIX + '/users'
                    @success "Deleted user '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Add user form.
        @get '/users_add', ->
            @show 'users', {}, {subpage: 'add'}

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
                    location = config.RESOURCES_PREFIX + '/users/'
                    location += (encodeURIComponent user.uri)
                    @redirect location
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
            query = switch @params.query
                when 'sample' then "sample: #{ @params.sample }"
                when 'group' then "group: #{ @params.group }"
                when 'custom' then @params.custom
                else '*'
            region =
                chromosome: @params.chromosome
                begin: @params.begin
                end: @params.end
            data =
                query: @params.query
                region: region

            # TODO: Our API methods don't return promises, so we promisify
            # some of them here. After promisification of our API this will be
            # obsolete.
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

            # We have a number of independent async requests to make:
            # 1. Get the variants from the API.
            # 2. Get the sample or group from the API (optional).
            requests = []

            requests.push getVariants
                query: query
                region: region
                page_number: parseInt @params.page ? 0

            switch @params.query
                when 'sample' then requests.push (getSample @params.sample).then (sample) ->
                    data.sample = sample
                when 'group' then requests.push (getGroup @params.group).then (group) ->
                    data.group = group
                else data.custom = @params.custom

            Promise.all requests
            .then ([result, ...]) =>
                data.variants = result.items
                @show 'variants', data, pagination: result.pagination
            .catch (error) =>
                @error error.message
