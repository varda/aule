# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Todo: Figure out roles and rights for variant lookup.


define ['jquery',
        'cs!config',
        'sammy',
        'handlebars',
        'moment',
        'jquery.base64',
        'sammy.handlebars'], ($, config, Sammy, Handlebars, moment) ->

    Sammy '#main', ->

        # Always call init() with an initialized Api instance before calling
        # run().
        @init = (api) => @api = api

        # Taken from Sammy.js EventContext private method.
        parseQueryString = (path) ->
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
            params = {}
            parts = path.match /\?([^#]*)?$/
            if parts and parts[1]
                pairs = parts[1].split '&'
                for p in pairs
                    pair = p.split '='
                    params = parseParamPair params, (decode pair[0]), (decode pair[1] ? '')
            params

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
            rights:
                list_samples: 'admin' in roles
                add_sample: 'importer' in roles or 'admin' in roles
                list_data_sources: 'admin' in roles
                add_data_source: true
                list_users: 'admin' in roles
                add_user: 'admin' in roles

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
        Handlebars.registerHelper 'query', (path, options) ->
            $.param $.extend (parseQueryString path), options.hash
        Handlebars.registerHelper 'dateFormat', (date, options) ->
            moment(date).format options.hash.format ? 'MMM Do, YYYY'
        Handlebars.registerHelper 'numberFormat', (number, options) ->
            number.toFixed options.hash.decimals ? 2

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

        # Lookup variant form.
        @get '/lookup_variant', ->
            # Todo: Due to pagination, this might not give all public samples.
            @app.api.samples
                filter: 'public'
                success: (items, pagination) =>
                    @show 'lookup', {samples: items}, {subpage: 'variant'}
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
                    if @params.sample
                        location += '?sample=' + (encodeURIComponent @params.sample)
                    @redirect location
                error: (code, message) => @error message
            return

        # Lookup variants form.
        @get '/lookup_region', ->
            # Todo: Due to pagination, this might not give all public samples.
            @app.api.samples
                filter: 'public'
                success: (items, pagination) =>
                    @show 'lookup', {samples: items}, {subpage: 'region'}
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
                if field in ['coverage_profile', 'public']
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
                    @redirect config.RESOURCES_PREFIX + '/sample'
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
                                {sample: sample, variations: items},
                                {subpage: 'variations', pagination: pagination}
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
                    @show 'user', {user: user}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Edit user.
        @post '/users/:user/edit', ->
            if not @params.dirty
                @error 'User is unchanged'
                return
            params = {}
            # Todo: Check password repeat.
            # Todo: More user-friendly way of setting roles.
            for field in @params.dirty.split ','
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
            # Todo: Check password repeat.
            # Todo: More user-friendly way of setting roles.
            @app.api.create_user
                data:
                    name: @params.name
                    login: @params.login
                    password: @params.password
                    roles: @params.roles
                success: (user) =>
                    location = config.RESOURCES_PREFIX + '/users/'
                    location += (encodeURIComponent user.uri)
                    @redirect location
                    @success "Added user '#{@params.name}'"
                error: (code, message) => @error message
            return

        # Show variant.
        @get '/variants/:variant', ->
            data = {}
            if @params.sample? then data.sample = @params.sample
            @app.api.variant @params.variant,
                data: data
                success: (variant) => @show 'variant', {variant: variant}
                error: (code, message) => @error message

        # List variants.
        @get '/variants', ->
            @app.api.variants
                sample: @params.sample
                region:
                    chromosome: @params.chromosome
                    begin: @params.begin
                    end: @params.end
                page_number: parseInt @params.page ? 0
                success: (items, pagination) =>
                    @show 'variants',
                        {variants: items, sample: {uri: @params.sample}},
                        {pagination: pagination}
                error: (code, message) => @error message
