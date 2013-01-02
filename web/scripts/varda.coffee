# Varda web
#
# For templating, we currently use Moustache templates via Sammy, but if we
# need more logic we might switch to something like JsRender or eco.
#
# Todo: Some sort of message mechanism (unobtrusive popups at bottom of screen
#     or something), i.e. to show authentication failures and other messages.
#
# https://github.com/BorisMoore/jsrender
# https://github.com/sstephenson/eco
#
# Copyright (c) 2011-2012, Leiden University Medical Center <humgen@lumc.nl>
# Copyright (C) 2011-2012, Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Prefix for resources such as templates
RESOURCES_PREFIX = '/varda-web'


# Root endpoint of Varda server
API_ROOT = '/'


# Create HTTP Basic Authentication header value
makeBasicAuth = (login, password) ->
    'Basic ' + $.base64.encode (login + ':' + password)


# Our Sammy application
app = Sammy '#main', ->

    # For templates
    @use Sammy.Handlebars, 'hb'

    Handlebars.registerHelper 'escape', (value) -> encodeURIComponent value
    Handlebars.registerHelper 'if_eq', (context, options) ->
        if context == options.hash.compare
            options.fn @
        else
            options.inverse @

    @helper 'template', (template) ->
        RESOURCES_PREFIX + '/templates/' + template + '.hb'

    @helper 'show', (title, template, data, page) ->
        $('h1').text title
        data?.current ?= page
        @partial (@template template), data,
            page: (@template page)
            pagination: (@template 'pagination')

    @helper 'server', (uri, options={}) ->
        options.type ?= 'GET'
        options.beforeSend ?= (r) -> null
        $.ajax uri,
            beforeSend: (r) => addAuth r; options.beforeSend r
            data: options.data
            success: options.success
            statusCode: statusHandlers this
            dataType: 'json'
            type: options.type

    @helper 'collection', (uri, title, template, options={}) ->
        options.current ?= template
        options.subtemplate ?= 'list'
        options.merge ?= {}
        page = parseInt @params.page ? 0
        @server uri,
            beforeSend: (addRange page)
            success: (data, _, xhr) =>
                $.extend data, options.merge
                data.current = options.current
                range = xhr.getResponseHeader 'Content-Range'
                total = parseInt (range.split '/')[1]
                pages = Math.ceil total / @app.pageSize
                if pages > 1
                    data.pages = for p in [0...pages]
                        page: p, label: p + 1, active: p == page
                    if page > 0 then data.pages.prev = page: page - 1, label: page
                    if page < pages - 1 then data.pages.next = page: page + 1, label: page + 2
                    if pages >= @app.manyPages then data.pages.many = true
                @show title, template, data, "#{ template }_#{ options.subtemplate }"

    # Authentication state
    @user = undefined
    @login = undefined
    @password = undefined

    # API resource URIs will be in here
    @uris = undefined

    # Number of items per page
    @pageSize = 50

    # Number of pages to be considered many
    @manyPages = 13

    # Add HTTP Basic Authentication header to request
    addAuth = (r) =>
        r.setRequestHeader 'Authorization', makeBasicAuth @login, @password

    addRange = (page) =>
        start = page * @pageSize
        end = start + @pageSize - 1
        (r) => r.setRequestHeader 'Range', "items=#{ start }-#{ end }"

    # Common handlers for response status codes
    statusHandlers = (context) ->
        400: -> context.log 'Server says bad request'
        401: -> context.show 'Authentication required', '401'
        403: -> context.show 'Request not allowed', '403'
        404: -> context.log 'Server says not found'
        501: -> context.show 'Not implemented', '501'

    # Index
    @get '/', ->
        @show 'Welcome', 'index'

    # Server info
    @get '/server', ->
        @server @app.uris.root,
            success: (r) => @show 'Server info', 'server', r

    # Authenticate
    @post '/authenticate', ->
        @app.login = @params['login']
        @app.password = @params['password']
        @server @app.uris.authentication,
            success: (r) =>
                @app.user = r.user
                @app.trigger 'authentication'
        return

    # List samples
    @get '/samples', ->
        @collection @app.uris.samples, 'Samples', 'samples'

    # List samples for current user
    @get '/samples_own', ->
        @collection "#{ @app.uris.samples }?user=#{ encodeURIComponent @app.user?.uri }",
            'Samples', 'samples', current: 'samples_own'

    # List public samples
    @get '/samples_public', ->
        @collection @app.uris.samples + '?public=true',
            'Samples', 'samples', current: 'samples_public'

    # Show sample
    @get '/samples/:sample', ->
        @server @params['sample'],
            success: (r) => @show "Sample: #{ r.sample.name }", 'sample', r, 'sample_show'

    # Edit sample
    @get '/samples/:sample/edit', ->
        @server @params['sample'],
            success: (r) => @show "Sample: #{ r.sample.name }", 'sample', r, 'sample_edit'

    # Delete sample
    @get '/samples/:sample/delete', ->
        @server @params['sample'],
            success: (r) => @show "Sample: #{ r.sample.name }", 'sample', r, 'sample_delete'

    # Sample variations
    @get '/samples/:sample/variations', ->
        @server @params.sample,
            success: (r) =>
                @collection "#{ @app.uris.variations }?embed=data_source&sample=#{ encodeURIComponent @params.sample }",
                    "Sample: #{ r.sample.name }", 'sample',
                        current: 'sample_variations'
                        subtemplate: 'variations'
                        merge: r

    # Sample coverages
    @get '/samples/:sample/coverages', ->
        @server @params.sample,
            success: (r) =>
                @collection "#{ @app.uris.coverages }?embed=data_source&sample=#{ encodeURIComponent @params.sample }",
                    "Sample: #{ r.sample.name }", 'sample',
                        current: 'sample_coverages',
                        subtemplate: 'coverages',
                        merge: r

    # Add sample form
    @get '/samples_add', ->
        @show 'Samples', 'samples', {}, 'samples_add'

    # Add sample
    @post '/samples', ->
        @server @app.uris.samples,
            data:
                name: @params['name']
                coverage_threshold: @params['coverage_threshold']
                pool_size: @params['pool_size']
            success: (r) => @redirect '/samples/' + encodeURIComponent r.sample
            type: 'POST'
        return

    # List data sources
    @get '/data_sources', ->
        @collection @app.uris.data_sources, 'Data sources', 'data_sources'

    # List data sources for current user
    @get '/data_sources_own', ->
        @collection "#{ @app.uris.data_sources }?user=#{ encodeURIComponent @app.user?.uri }",
            'Data sources', 'data_sources', current: 'data_sources_own'

    # Show data source
    @get '/data_sources/:data_source', ->
        @server @params['data_source'],
            success: (r) => @show "Data source: #{ r.data_source.name }", 'data_source', r

    # Add data source form
    @get '/data_sources_add', ->
        @show 'Data sources', 'data_sources', 'data_sources_add'

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

    # List users
    @get '/users', ->
        @collection @app.uris.users, 'Users', 'users'

    # Show user
    @get '/users/:user', ->
        @server @params['user'],
            success: (r) => @show "User: #{ r.user.name }", 'user', r

    # Add user form
    @get '/users_add', ->
        @show 'Users', 'users', {}, 'users_add'

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

    # Authentication event
    @bind 'authentication', =>
        $('#form-authenticate').removeClass 'success fail'
        $('#nav .user').remove()
        if @user?
            state = 'success'
            $('#nav').prepend $("<li class='nav-header user'>#{ @user.name }</hli>
                                 <li class='user'><a href='#'>Profile</a></li>")
        else
            state = 'fail'
        $('#form-authenticate').addClass state
        @refresh()


# On document ready
$ ->

    # Capture authentication form submit with Sammy (it's outside its element)
    $('#form-authenticate').bind 'submit', (e) ->
        returned = app._checkFormSubmission $(e.target).closest 'form'
        if returned is false
            e.preventDefault()
        else
            false

    # Clear the authentication status when we type
    $('#form-authenticate input').bind 'input', ->
        $('#form-authenticate').removeClass 'success fail'
        $('#nav .user').remove()

    # Todo: .live is deprecated
    $('tbody tr[data-href]').live 'click', (e) ->
        e.preventDefault()
        # Todo: Better to just trigger the a.click event?
        app.setLocation $(this).data('href')

    # Get resource URIs and run app
    # Todo: error handling
    $.ajax API_ROOT,
        success: (r) =>
            app.uris =
                root: API_ROOT
                samples: r.samples_uri
                variations: r.variations_uri
                coverages: r.coverages_uri
                data_sources: r.data_sources_uri
                annotations: r.annotations_uri
                users: r.users_uri
                authentication: r.authentication_uri
            app.run()
            $('#varda').show()
            $('#loading').fadeOut 'fast'
        dataType: 'json'
