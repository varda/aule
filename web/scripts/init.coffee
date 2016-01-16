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

        # Helper function for updating dirty flags on edit forms. Both
        # arguments should be jQuery objects.
        setDirty = (field, label) ->
            field.addClass 'dirty'
            label.addClass 'dirty'
            # Here we aggregate the names of the dirty form fields into the
            # field '#dirty'. Unfortunately I couldn't manage to do this in
            # the form submit handler because it would always be called after
            # the Sammy route was called. So we do this aggregation on every
            # field change (this includes pressing a key in a text field).
            form = field.closest 'form'
            #$('#dirty', form).val ($(x).attr 'name' for x in $(':input.dirty', form))
            $('#dirty', form).val (for x in $(':input.dirty, .form-picker.dirty', form)
                                       ($(x).attr 'name') or ($(x).data 'name'))

        # Keep track of dirty fields in edit forms.
        $(document).on 'input', '.form-edit :input', ->
            setDirty $(@), $("label[for='#{ @id }']")
        $(document).on 'change','.form-edit input:checkbox, .form-edit input:radio', ->
            setDirty $(@), $(@).parent('label')
        $(document).on 'reset', '.form-edit', ->
            $(':input, .form-picker, label', @).removeClass 'dirty'
            $('#dirty', @).val []

        # Facilitate clicking anywhere in a table row.
        $(document).on 'click', 'tbody tr[data-href]', (e) ->
            e.preventDefault()
            app.setLocation $(this).data('href')

        # Open the picker modal.
        $(document).on 'click', 'a.picker-open', (e) ->
            e.preventDefault()
            $('#picker').data('source', $(this).closest('.form-picker'))
            app.runRoute 'get', $(this).attr('href')

        # Clicking a row in the picker.
        $('#picker').on 'click', 'tbody tr[data-value]', (e) ->
            e.preventDefault()
            source = $('#picker').data('source')
            add = $('div', source).last()
            element = $("<div>
                <input name=\"#{ source.data 'name' }\" type=\"hidden\" value=\"#{ $(this).data 'value' }\">
                <i class=\"icon-remove\"></i> #{ $(this).data 'name' }
              </div>")
            add.before(element)
            if not source.data 'multi'
                add.hide()
            setDirty source, $("label[for='#{ source.data 'name' }']")
            $('#picker').modal('hide')

        # Removing an element from a picker field.
        $(document).on 'click', '.form-picker div i', (e) ->
            element = $(this).closest('div')
            source = element.parent()
            add = $('div', source).last()
            element.remove()
            add.show()
            setDirty source, $("label[for='#{ source.data 'name' }']")

        # Navigation in the picker modal.
        $('#picker').on 'click', 'a', (e) ->
            e.preventDefault()
            app.runRoute 'get', $(this).attr('href')

        # Reset all pickers.
        $(document).on 'reset', 'form', ->
            $('.form-picker', @).each ->
                add = $('div', this).last().detach()
                $('div', this).remove()
                add.appendTo this
                add.show()

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
