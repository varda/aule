# Varda web client
#
# For templating, we currently use Moustache templates via Sammy, but if we
# need more logic we might switch to something like JsRender or eco.
#
# Todo: Possibly auto reload current page after (re-)authenticating?
#
# https://github.com/BorisMoore/jsrender
# https://github.com/sstephenson/eco
#
# 2011, Martijn Vermaat <m.vermaat.hg@lumc.nl>


# Create HTTP Basic Authentication header value
makeBasicAuth = (login, password) ->
    'Basic ' + $.base64.encode (login + ':' + password)


# Set authentication state
setAuthentication = (user) ->
    clearAuthentication()
    if user?
        state = 'success'
        showUser user
    else
        state = 'fail'
    $('#form-authenticate').addClass state


# Clear authentication state
clearAuthentication = ->
    $('#form-authenticate').removeClass 'success fail'
    $('#userbar').empty()


# Show user in sidebar
showUser = (user) ->
    $('#userbar').empty().append $("<h3>#{ user.name }</h3><p>Roles: #{ user.roles.join ', ' }</p>")


# Our Sammy application
app = Sammy '#main', ->

    # For templates
    @use('Mustache');

    # Authentication state
    @user = undefined
    @login = undefined
    @password = undefined

    # Index
    @get '/', ->
        @$element().html 'Haha, this is the index :)'

    # Status
    @get '/status', ->
        $.ajax '/api/v1/',
            success: (r) => @partial '/templates/status.mustache', status: r.api.status
            dataType: 'json'

    # Authenticate
    @post '/authenticate', ->
        @app.login = @params['login']
        @app.password = @params['password']
        $.ajax '/api/v1/authentication',
            beforeSend: (r) =>
                r.setRequestHeader 'Authorization', makeBasicAuth @app.login, @app.password
            success: (r) =>
                @app.user = r.authentication.user
                @app.trigger 'authentication'
            dataType: 'json'

    # List samples
    @get '/samples', ->
        $.ajax '/api/v1/samples',
            beforeSend: (r) =>
                r.setRequestHeader 'Authorization', makeBasicAuth @app.login, @app.password
            success: (r) => @partial '/templates/samples.mustache', samples: r.samples
            statusCode: 401: => @partial '/templates/401.mustache'
            dataType: 'json'

    # Show sample
    @get '/samples/:sample', ->
        $.ajax "/api/v1/samples/#{ @params['sample'] }",
            beforeSend: (r) =>
                r.setRequestHeader 'Authorization', makeBasicAuth @app.login, @app.password
            success: (r) => @partial '/templates/sample.mustache', sample: r.sample
            statusCode: 401: => @partial '/templates/401.mustache'
            dataType: 'json'

    # Authentication event
    @bind 'authentication', =>
        setAuthentication @user
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
    $('#form-authenticate input').bind 'input',  -> clearAuthentication()

    # Todo: .live is deprecated
    $('tbody tr').live 'click', ->
        # Todo: Better to just trigger the a.click event?
        app.setLocation $(this).find('td a').first().attr('href')

    app.run()
