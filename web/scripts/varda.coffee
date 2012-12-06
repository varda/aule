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

    @helper 'template', (template) ->
        RESOURCES_PREFIX + '/templates/' + template + '.hb'
    @helper 'show', (title, template, data, page) ->
        $('h1').text title
        @partial (@template template), data, page: (@template page)

    # Authentication state
    @user = undefined
    @login = undefined
    @password = undefined

    # API resource URIs will be in here
    @uris = undefined

    # Add HTTP Basic Authentication header to request
    addAuthHeader = (r) =>
        r.setRequestHeader 'Authorization', makeBasicAuth @login, @password

    # Common handlers for response status codes
    # Todo: It is unfortunate that we need the context here to call partial...
    statusHandlers = (context) ->
        400: -> context.log 'Server says bad request'
        401: -> context.show 'Authentication required', '401'
        403: -> context.log 'Server says forbidden'
        404: -> context.log 'Server says not found'

    # Index
    @get '/', ->
        @show 'Welcome', 'index'

    # Server info
    @get '/server', ->
        $.ajax @app.uris.root,
            success: (r) => @show 'Server info', 'server', r
            dataType: 'json'

    # Authenticate
    @post '/authenticate', ->
        @app.login = @params['login']
        @app.password = @params['password']
        $.ajax @app.uris.authentication,
            beforeSend: addAuthHeader
            success: (r) =>
                @app.user = r.authentication.user
                @app.trigger 'authentication'
            dataType: 'json'
        return

    # List samples
    @get '/samples', ->
        $.ajax @app.uris.samples,
            beforeSend: addAuthHeader
            success: (r) => @show 'Samples', 'samples', r, 'samples_list'
            statusCode: statusHandlers this
            dataType: 'json'

    # List samples for current user
    @get '/my_samples', ->
        $.ajax (expand '/users/martijn/samples'),
            beforeSend: addAuthHeader
            success: (r) => @show 'Samples', 'samples', r, 'samples_list'
            statusCode: statusHandlers this
            dataType: 'json'

    # Show sample
    @get '/samples/:sample', ->
        $.ajax (expand @params['sample']),
            beforeSend: addAuthHeader
            success: (r) => @show "Sample: #{ r.name }" 'sample', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Add sample form
    @get '/add_sample', -> @show 'Samples', 'samples', {}, 'samples_add'

    # Add sample
    @post '/samples', ->
        $.ajax (expand '/samples'),
            beforeSend: addAuthHeader
            data:
                name: @params['name']
                coverage_threshold: @params['coverage_threshold']
                pool_size: @params['pool_size']
            success: (r) => @redirect '/samples/' + encodeURIComponent r.sample
            statusCode: statusHandlers this
            dataType: 'json'
            type: 'POST'
        return

    # List data sources
    @get '/data_sources', ->
        @uri 'data_sources', (uri) =>
            $.ajax uri,
                beforeSend: addAuthHeader
                success: (r) => @show 'Data sources', 'data_sources', r, 'data_sources_list'
                statusCode: statusHandlers this
                dataType: 'json'

    # Show data source
    @get '/data_sources/:data_source', ->
        $.ajax (expand @params['data_source']),
            beforeSend: addAuthHeader
            success: (r) => @partial RESOURCES_PREFIX + '/templates/data_source.mustache', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Add data source form
    @get '/add_data_source', ->
        @partial RESOURCES_PREFIX + '/templates/add_data_source.mustache'

    # Add data source
    @post '/data_sources', ->
        $.ajax (expand '/data_sources'),
            beforeSend: addAuthHeader
            data:
                name: @params['name']
                filetype: @params['filetype']
                local_path: @params['local_path']
            success: (r) => @redirect '/data_sources/' + encodeURIComponent r.data_source
            statusCode: statusHandlers this
            dataType: 'json'
            type: 'POST'
        return

    # List users
    @get '/users', ->
        $.ajax (expand '/users'),
            beforeSend: addAuthHeader
            success: (r) => @partial RESOURCES_PREFIX + '/templates/users.mustache', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Show user
    @get '/users/:user', ->
        $.ajax (expand @params['user']),
            beforeSend: addAuthHeader
            success: (r) => @partial RESOURCES_PREFIX + '/templates/user.mustache', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Add user form
    @get '/add_user', ->
        @partial RESOURCES_PREFIX + '/templates/add_user.mustache'

    # Add user
    @post '/users', ->
        $.ajax (expand '/users'),
            beforeSend: addAuthHeader
            data:
                name: @params['name']
                login: @params['login']
                password: @params['password']
                roles: @params['roles']
            success: (r) => @redirect '/users/' + encodeURIComponent r.user
            statusCode: statusHandlers this
            dataType: 'json'
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
                samples: r.api.collections.samples
                data_sources: r.api.collections.data_sources
                users: r.api.collections.users
                authentication: r.api.authentication
            app.run()
            $('#varda').show()
            $('#loading').fadeOut 'fast'
        dataType: 'json'
