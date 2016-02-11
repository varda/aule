# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Todo: Cache resources.
# Todo: Proper URI construction instead of string concatenations.


$ = require 'jquery'
Promise = require 'bluebird'
URI = require 'urijs'

config = require 'config'


# Accepted server API versions.
ACCEPT_VERSION = '>=3.0.0,<4.0.0'

# Create HTTP Basic Authentication header value.
makeBasicAuth = (login, password) ->
  'Basic ' + window.btoa (login + ':' + password)

# Add HTTP Basic Authentication header to request.
addAuth = (r, login, password) ->
  r.setRequestHeader 'Authorization', makeBasicAuth login, password if login

# Add Accept-Version header to request.
addVersion = (r) ->
  r.setRequestHeader 'Accept-Version', ACCEPT_VERSION

# Add Range header to request for collection resources.
addRangeForPage = (page, page_size=config.PAGE_SIZE) ->
  start = page * page_size
  end = start + page_size - 1
  (r) -> r.setRequestHeader 'Range', "items=#{ start }-#{ end }"


class ApiError extends Error
  constructor: (@code, @message) ->
    @name = 'ApiError'


class Api
  constructor: (@root) ->

  init: =>
    @request @root
    .then ({root}) =>
      if root.status != 'ok'
        throw new ApiError 'response_error', 'Unexpected response from server'
      @uris =
        root: @root
        authentication: root.authentication.uri
        genome: root.genome.uri
        annotations: root.annotation_collection.uri
        coverages: root.coverage_collection.uri
        data_sources: root.data_source_collection.uri
        groups: root.group_collection.uri
        samples: root.sample_collection.uri
        tokens: root.token_collection.uri
        users: root.user_collection.uri
        variants: root.variant_collection.uri
        variations: root.variation_collection.uri

  annotation: (uri) =>
    @request uri + '?embed=original_data_source,annotated_data_source'
    .then ({annotation}) -> annotation

  annotations: ({filter, page_number}={}) =>
    uri = @uris.annotations +
          '?embed=original_data_source,annotated_data_source'
    uri += '&annotated_data_source.user=' +
           encodeURIComponent @current_user?.uri if filter == 'own'
    @collection uri, 'annotation', {page_number}

  create_annotation: (data) =>
    data.queries = [name: 'QUERY', expression: data.query]
    delete data.query
    @request @uris.annotations, {data, method: 'POST'}
    .then ({annotation}) -> annotation

  authenticate: (@login, @password) =>
    @current_user = null
    @request @uris.authentication
    .then ({authentication}) =>
      if authentication.authenticated
        @current_user = authentication.user
      else
        throw new ApiError 'authentication_error',
          "Unable to authenticate with login '#{@login}' and password '***'"

  coverages: ({sample, page_number}={}) =>
    uri = @uris.coverages + '?embed=data_source'
    uri += "&sample=#{ encodeURIComponent sample }" if sample?
    @collection uri, 'coverage', {page_number}

  data_source: (uri) =>
    @request uri + '?embed=user'
    .then ({data_source}) -> data_source

  data_sources: ({filter, page_number}={}) =>
    uri = @uris.data_sources
    uri += "?user=#{ encodeURIComponent @current_user?.uri }" if filter == 'own'
    @collection uri, 'data_source', {page_number}

  create_data_source: (data) =>
    @request @uris.data_sources, {data, method: 'POST'}
    .then ({data_source}) -> data_source

  edit_data_source: (uri, data) =>
    @request uri, {data, method: 'PATCH'}
    .then ({data_source}) -> data_source

  delete_data_source: (uri) =>
    @request uri, method: 'DELETE'

  genome: =>
    @request @uris.genome
    .then ({genome}) -> genome

  group: (uri) =>
    @request uri
    .then ({group}) -> group

  groups: ({page_number}={}) =>
    @collection @uris.groups, 'group', {page_number}

  create_group: (data) =>
    @request @uris.groups, {data, method: 'POST'}
    .then ({group}) -> group

  edit_group: (uri, data) =>
    @request uri, {data, method: 'PATCH'}
    .then ({group}) -> group

  delete_group: (uri) =>
    @request uri, method: 'DELETE'

  sample: (uri) =>
    @request uri + '?embed=user,groups'
    .then ({sample}) -> sample

  samples: ({filter, group, page_number}={}) =>
    uri = @uris.samples
    uri += "?user=#{ encodeURIComponent @current_user?.uri }" if filter == 'own'
    uri += '?public=true' if filter == 'public'
    uri += "?groups=#{ encodeURIComponent group }" if group?
    @collection uri, 'sample', {page_number}

  create_sample: (data) =>
    @request @uris.samples, {data, method: 'POST'}
    .then ({sample}) -> sample

  edit_sample: (uri, data) =>
    @request uri, {data, method: 'PATCH'}
    .then ({sample}) -> sample

  delete_sample: (uri) =>
    @request uri, method: 'DELETE'

  token: (uri) =>
    @request uri
    .then ({token}) -> token

  tokens: ({filter, page_number}={}) =>
    uri = @uris.tokens
    uri += "?user=#{ encodeURIComponent @current_user?.uri }" if filter == 'own'
    @collection uri, 'token', {page_number}

  create_token: (data) =>
    @request @uris.tokens, {data, method: 'POST'}
    .then ({token}) -> token

  edit_token: (uri, data) =>
    @request uri, {data, method: 'PATCH'}
    .then ({token}) -> token

  delete_token: (uri) =>
    @request uri, method: 'DELETE'

  user: (uri) =>
    @request uri
    .then ({user}) -> user

  users: ({page_number}={}) =>
    @collection @uris.users, 'user', {page_number}

  create_user: (data) =>
    @request @uris.users, {data, method: 'POST'}
    .then ({user}) -> user

  edit_user: (uri, data) =>
    @request uri, {data, method: 'PATCH'}
    .then ({user}) -> user

  delete_user: (uri) =>
    @request uri, method: 'DELETE'

  variations: ({sample, page_number}={}) =>
    uri = @uris.variations + '?embed=data_source'
    uri += "&sample=#{ encodeURIComponent sample }" if sample?
    @collection uri, 'variation', {page_number}

  variant: (uri, {query, region}={}) =>
    # The queries structure is too complex to send as a regular query string
    # parameter and we cannot send a request body with GET, so we use the
    # __json__ query string parameter workaround.
    json =
      queries: [name: 'QUERY', expression: query]
      region: region
    uri += "?__json__=#{ encodeURIComponent (JSON.stringify json) }"
    @request uri
    .then ({variant}) ->
      # We only support one query, so we flatten the query results.
      variant.coverage = variant.annotations.QUERY.coverage
      variant.frequency = variant.annotations.QUERY.frequency
      variant.frequency_het = variant.annotations.QUERY.frequency_het
      variant.frequency_hom = variant.annotations.QUERY.frequency_hom
      variant

  variants: ({query, region, page_number}={}) =>
    uri = @uris.variants
    # The queries structure is too complex to send as a regular query string
    # parameter and we cannot send a request body with GET, so we use the
    # __json__ query string parameter workaround.
    json =
      queries: [name: 'QUERY', expression: query]
      region: region
    uri += "?__json__=#{ encodeURIComponent (JSON.stringify json) }"
    @collection uri, 'variant', {page_number}
    .then ({items, pagination}) ->
      # We only support one query, so we flatten the query results.
      for item in items
        item.coverage = item.annotations.QUERY.coverage
        item.frequency = item.annotations.QUERY.frequency
        item.frequency_het = item.annotations.QUERY.frequency_het
        item.frequency_hom = item.annotations.QUERY.frequency_hom
      {items, pagination}

  create_variant: (data) =>
    @request @uris.variants, {data, method: 'POST'}
    .then ({variant}) -> variant

  collection: (uri, type, options={}) =>
    options.page_number ?= 0
    options.page_size ?= config.PAGE_SIZE
    @request uri,
      beforeSend: addRangeForPage options.page_number, config.PAGE_SIZE
      data: options.data
      includeXhr: true
    .then ({data, xhr}) ->
      range = xhr.getResponseHeader 'Content-Range'
      total = parseInt (range.split '/')[1]
      pagination =
        total: Math.ceil total / options.page_size
        current: options.page_number
      items: data["#{ type }_collection"].items
      pagination: pagination
    .catch code: 'unsatisfiable_range', ->
      items: []
      pagination: {total: 0, current: 0}

  request: (uri, options={}) =>
    uri = URI(uri).absoluteTo(@root).toString()
    xhr = $.ajax uri,
      beforeSend: (r) =>
        addAuth r, @login, @password
        addVersion r
        options.beforeSend? r
      data: JSON.stringify options.data
      dataType: 'json'
      type: options.method ? 'GET'
      contentType: 'application/json; charset=utf-8' if options.data?
    Promise.resolve xhr
    .then (data) ->
      # Promisifying $.ajax we loose the jqXHR object. In rare situations we
      # still need that, so we optionally return a wrapper object.
      if options.includeXhr then {data, xhr} else data
    .catch ({status, responseText}) ->
      try
        {code, message} = ($.parseJSON responseText).error
      catch e
        if not status
          code = 'connection_error'
          message = 'Unable to connect to server'
        else if status == 503
          code = 'maintenance'
          message = 'The server is currently undergoing maintenance'
        else
          code = 'response_error'
          message = "Unable to parse server response
                     (status: #{status} #{statusText})"
          console.log 'Unable to parse server response'
          console.log responseText
      throw new ApiError code, message


module.exports = {ApiError, Api}
