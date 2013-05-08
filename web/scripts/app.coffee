# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


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
            return
        Handlebars.registerHelper 'query', (path, options) ->
            $.param $.extend (parseQueryString path), options.hash
        Handlebars.registerHelper 'dateFormat', (date, options) ->
            moment(date).format options.hash.format ? 'MMM Do, YYYY'

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
            data.base = config.RESOURCES_PREFIX
            data.path = @path
            data.page = page
            data.subpage = options.subpage
            if @app.api.current_user?
                # Todo: Refactor the whole roles/rights thing.
                roles = @app.api.current_user.roles
                data.auth =
                    user: @app.api.current_user
                    rights:
                        list_samples: 'admin' in roles
                        add_sample: 'importer' in roles or 'admin' in roles
                        list_data_sources: 'admin' in roles
                        add_data_source: true
                        list_users: 'admin' in roles
                        add_user: 'admin' in roles
            partials = {}
            if options.subpage?
                partials.subpage = @template "#{page}_#{options.subpage}"
            if options.pagination?
                partials.pagination = @template 'pagination'
                if options.pagination.total > 1
                    data.pagination =
                        pages:
                            for p in [0...options.pagination.total]
                                page: p
                                label: p + 1
                                active: p == options.pagination.current
                        many_pages:
                            options.pagination.total >= config.MANY_PAGES
                    if options.pagination.current > 0
                        data.pagination.previous =
                            page: options.pagination.current - 1
                            label: options.pagination.current
                    if options.pagination.current < options.pagination.total - 1
                        data.pagination.next =
                            page: options.pagination.current + 1
                            label: options.pagination.current + 2
            @partial (@template page), data, partials

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
                    @show 'data_source', data_source: data_source
                error: (code, message) => @error message

        # Add data source form.
        @get '/data_sources_add', ->
            @show 'data_sources', {}, {subpage: 'add'}

        # Add data source
        @post '/data_sources', ->
            @server @app.uris.data_sources,
                data:
                    name: @params['name']
                    filetype: @params['filetype']
                    local_path: @params['local_path']
                success: (r) => @redirect '/data_sources/' + encodeURIComponent r.data_source
                type: 'POST'
            return

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

        # Add sample
        @post '/samples', ->
            @server @app.uris.samples,
                data:
                    name: @params.name
                    pool_size: @params.pool_size
                success: (r) => @redirect '/samples/' + encodeURIComponent r.sample_uri
                type: 'POST'
            return

        # Show sample.
        @get '/samples/:sample', ->
            @app.api.sample @params.sample,
                success: (sample) =>
                    @show 'sample', {sample: sample}, {subpage: 'show'}
                error: (code, message) => @error message

        # Edit sample.
        @get '/samples/:sample/edit', ->
            @app.api.sample @params.sample,
                success: (sample) =>
                    @show 'sample', {sample: sample}, {subpage: 'edit'}
                error: (code, message) => @error message

        # Delete sample.
        @get '/samples/:sample/delete', ->
            @app.api.sample @params.sample,
                success: (sample) =>
                    @show 'sample', {sample: sample}, {subpage: 'delete'}
                error: (code, message) => @error message

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

        # List users
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
                    @show 'user', user: user
                error: (code, message) => @error message

        # Add user form.
        @get '/users_add', ->
            @show 'users', {}, {subpage: 'add'}

        # Add user
        @post '/users', ->
            @server @app.uris.users,
                data:
                    name: @params['name']
                    login: @params['login']
                    password: @params['password']
                    roles: @params['roles']
                success: (r) => @redirect '/users/' + encodeURIComponent r.user
                type: 'POST'
            return

        # Lookup variant form.
        @get '/variants_variant', ->
            # Todo: Due to pagination, this might not give all public samples.
            @app.api.samples
                filter: 'public'
                success: (items, pagination) =>
                    @show 'variants', {samples: items}, {subpage: 'variant'}
                error: (code, message) => @error message

        # Lookup variants form.
        @get '/variants_region', ->
            # Todo: Due to pagination, this might not give all public samples.
            @app.api.samples
                filter: 'public'
                success: (items, pagination) =>
                    @show 'variants', {samples: items}, {subpage: 'region'}
                error: (code, message) => @error message

        # Show variant.
        @get '/variants/:variant', ->
            data = {}
            if @params.sample? then data.sample = @params.sample
            @app.api.variant @params.variant,
                data: data
                success: (variant) => @show 'variant', {variant: variant}
                error: (code, message) => @error message

        # Lookup variant
        @post '/variants_variant', ->
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
