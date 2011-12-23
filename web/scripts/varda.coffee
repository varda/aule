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
setAuthentication = (authenticated, user) ->
    clearAuthentication()
    if authenticated
        state = 'success'
        showUser user
    else
        state ='fail'
    $('#form-authenticate').addClass state


# Clear authentication state
clearAuthentication = ->
    $('#form-authenticate').removeClass 'success fail'
    $('#userbar').empty()


# Show user in sidebar
showUser = (user) ->
    $('#userbar').empty().append $("<h3>#{ user.name }</h3><p>Roles: #{ user.roles.join ', ' }</p>")


app = Sammy '#main', ->
    @use('Mustache');
    @get '/', ->
        @$element().html 'Haha, this is the index :)'
    @get '/status', ->
        $.ajax '/api/v1/',
            success: (r) => @partial '/templates/status.mustache', status: r.api.status
            dataType: 'json'
    @post '/authenticate', ->
        $.ajax '/api/v1/authentication',
            beforeSend: (r) =>
                r.setRequestHeader 'Authorization', makeBasicAuth @params['login'], @params['password']
            success: (r) ->
                setAuthentication r.authentication.authenticated, r.authentication.user
            dataType: 'json'


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

    app.run()
