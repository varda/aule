# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Todo: Have some default CSS on #loading to make it look pretty even before
#     the LESS stylesheets are downloaded and compiled.


define ['jquery', 'cs!config', 'cs!api', 'cs!app'], ($, config, Api, app) ->

    # On document ready
    $ ->

        # Capture authentication form submit with Sammy (it's outside its
        # element).
        $('#form-authenticate').bind 'submit', (e) ->
            returned = app._checkFormSubmission $(e.target).closest 'form'
            if returned is false
                e.preventDefault()
            else
                false

        # Clear the authentication status when we type.
        $('#form-authenticate input').bind 'input', ->
            $('#form-authenticate').removeClass 'success fail'

        # Facilitate clicking anywhere in a table row.
        $(document).delegate 'tbody tr[data-href]', 'click', (e) ->
            e.preventDefault()
            # Todo: Better to just trigger the a.click event?
            app.setLocation $(this).data('href')

        # Show the user that we are waiting for the server.
        $(document)
            .bind('ajaxStart', ->
                $('#waiting').fadeIn duration: 'slow', queue: false
                $('button').prop 'disabled', true)
            .bind('ajaxStop', ->
                $('#waiting').fadeOut duration: 'fast', queue: false
                $('button').prop 'disabled', false)

        # Instantiate API client and run app.
        api = new Api config.API_ROOT
        api.init
            error: (code, message) ->
                $('#loading').append $(
                    """
                    <div class="modal-error">
                        <p class="alert alert-error">
                            <strong>Error:</strong> #{message}
                        </p>
                    </div>
                    """)
            success: ->
                app.init api
                app.run()
                $('#aule').show()
                $('#loading').fadeOut 'fast'
