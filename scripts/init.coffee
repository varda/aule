# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


$ = require 'jquery'
td = require 'throttle-debounce'

config = require 'config'
{ApiError, Api} = require './api'
app = require './app'


require 'bootstrap/js/bootstrap-alert'
require 'bootstrap/js/bootstrap-collapse'
require 'bootstrap/js/bootstrap-modal'
require 'bootstrap/js/bootstrap-transition'
require 'bootstrap/less/bootstrap.less'
require 'bootstrap/less/responsive.less'
require '../stylesheets/aule.less'


# On document ready
$ ->

  # Capture authentication form submit with Sammy (it's outside its
  # element).
  $(document).on 'submit', '#form-authenticate', (e) ->
    returned = app._checkFormSubmission $(e.target).closest 'form'
    if returned is false
      e.preventDefault()
    else
      false

  # Clear the authentication status when we type.
  $(document).on 'input', '#form-authenticate input', ->
    $('#form-authenticate').removeClass 'success fail'

  # Helper function for updating dirty flags on edit forms. Both
  # arguments should be jQuery objects.
  setDirty = (field, label) ->
    field.addClass 'dirty'
    label.addClass 'dirty'
    # Here we aggregate the names of the dirty form fields into the field
    # '#dirty'. Unfortunately I couldn't manage to do this in the form
    # submit handler because it would always be called after the Sammy
    # route was called. So we do this aggregation on every field change
    # (this includes pressing a key in a text field).
    form = field.closest 'form'
    #$('#dirty', form).val ($(x).attr 'name' for x in $(':input.dirty', form))
    $('#dirty', form).val (for x in $(':input.dirty, .form-picker.dirty', form)
      ($(x).attr 'name') or ($(x).data 'name'))

  # Keep track of dirty fields in edit forms.
  $(document).on 'input', '.form-edit :input', ->
    setDirty $(@), $("label[for='#{ @id }']")
  $(document).on 'change','.form-edit input:checkbox, .form-edit input:radio',
    -> setDirty $(@), $(@).parent('label')
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
  $(document).on 'click', '#picker tbody tr[data-value]', (e) ->
    e.preventDefault()
    source = $('#picker').data('source')
    add = $('div', source).last()
    element = $("<div>
      <input name=\"#{ source.data 'name' }\" type=\"hidden\"
             value=\"#{ $(this).data 'value' }\">
      <i class=\"fa fa-remove\"></i> #{ $(this).data 'name' }
    </div>")
    add.before(element)
    add.hide() unless source.data 'multi'
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
  $(document).on 'click', '#picker a', (e) ->
    e.preventDefault()
    app.runRoute 'get', $(this).attr('href')

  # Reset all pickers.
  $(document).on 'reset', 'form', ->
    $('.form-picker', @).each ->
      add = $('div', this).last().detach()
      $('div', this).remove()
      add.appendTo this
      add.show()

  # Transcript query input element.
  $(document).on 'input', '.transcript-querier', td.debounce 250, ->
    route = "#{ config.RESOURCES_PREFIX }/transcript_query"
    app.runRoute 'get', route, query: $(@).val().trim()

  # Show the user that we are waiting for the server.
  $(document)
    .bind('ajaxStart', ->
      $('#waiting').fadeIn duration: 'slow', queue: false
      $('button').prop 'disabled', true)
    .bind('ajaxStop', ->
      $('#waiting').fadeOut duration: 'fast', queue: false
      $('button').prop 'disabled', false)

  # Instantiate API client and run app.
  $('body').html require('../templates/loading.hb')()
  api = new Api config.API_ROOT
  api.init()
  .then ->
    $('body').html require('../templates/application.hb') base: config.BASE
    app.init api
    app.run()
  .catch ApiError, (error) ->
    $('body').html require('../templates/loading_error.hb') error: error


module.exports = {}
