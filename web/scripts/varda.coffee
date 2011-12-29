# Varda web client
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
# 2011, Martijn Vermaat <m.vermaat.hg@lumc.nl>


# Create HTTP Basic Authentication header value
makeBasicAuth = (login, password) ->
    'Basic ' + $.base64.encode (login + ':' + password)


# Our Sammy application
app = Sammy '#main', ->

    # For templates
    @use('Mustache');

    # Authentication state
    @user = undefined
    @login = undefined
    @password = undefined

    # Add HTTP Basic Authentication header to request
    addAuthHeader = (r) =>
        r.setRequestHeader 'Authorization', makeBasicAuth @login, @password

    # Common handlers for response status codes
    # Todo: It is unfortunate that we need the context here to call partial...
    statusHandlers = (context) ->
        401: -> context.partial '/templates/401.mustache'

    # Index
    @get '/', ->
        @$element().html 'Haha, this is the index :)'

    # Status
    @get '/status', ->
        $.ajax '/api/v1/',
            success: (r) => @partial '/templates/status.mustache', r.api
            dataType: 'json'

    # Authenticate
    @post '/authenticate', ->
        @app.login = @params['login']
        @app.password = @params['password']
        $.ajax '/api/v1/authentication',
            beforeSend: addAuthHeader
            success: (r) =>
                @app.user = r.authentication.user
                @app.trigger 'authentication'
            dataType: 'json'
        return

    # List samples
    @get '/samples', ->
        $.ajax '/api/v1/samples',
            beforeSend: addAuthHeader
            success: (r) => @partial '/templates/samples.mustache', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Show sample
    @get '/samples/:sample', ->
        $.ajax "/api/v1/samples/#{ @params['sample'] }",
            beforeSend: addAuthHeader
            success: (r) => @partial '/templates/sample.mustache', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Add sample
    @post '/samples', ->
        $.ajax '/api/v1/samples',
            beforeSend: addAuthHeader
            data:
                name: @params['name']
                coverage_threshold: @params['coverage_threshold']
                pool_size: @params['pool_size']
            success: (r) => @redirect "/samples/#{ r.sample.id }"
            statusCode: statusHandlers this
            dataType: 'json'
            type: 'POST'
        return

    # List users
    @get '/users', ->
        $.ajax '/api/v1/users',
            beforeSend: addAuthHeader
            success: (r) => @partial '/templates/users.mustache', r
            statusCode: statusHandlers this
            dataType: 'json'

    # Authentication event
    @bind 'authentication', =>
        $('#form-authenticate').removeClass 'success fail'
        $('#userbar').empty()
        if @user?
            state = 'success'
            $('#userbar').append $("<h3>#{ @user.name }</h3>
                                    <p>Roles: #{ @user.roles.join ', ' }</p>
                                    <hr>")
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
        $('#userbar').empty()

    # Todo: .live is deprecated
    $('tbody tr').live 'click', (e) ->
        e.preventDefault()
        # Todo: Better to just trigger the a.click event?
        app.setLocation $(this).find('td a').first().attr('href')

    app.run()
