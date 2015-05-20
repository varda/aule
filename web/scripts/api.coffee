# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


# Todo: Cache resources.


define ['jquery', 'cs!config', 'jquery.base64'], ($, config) ->

    # Accepted server API versions.
    ACCEPT_VERSION = '>=1.0.0,<2.0.0'

    # Create HTTP Basic Authentication header value.
    makeBasicAuth = (login, password) ->
        'Basic ' + $.base64.encode (login + ':' + password)

    # Add HTTP Basic Authentication header to request.
    addAuth = (r, login, password) ->
        if login
            r.setRequestHeader 'Authorization', makeBasicAuth login, password

    # Add Accept-Version header to request.
    addVersion = (r) ->
        r.setRequestHeader 'Accept-Version', ACCEPT_VERSION

    # Add Range header to request for collection resources.
    addRangeForPage = (page, page_size=config.PAGE_SIZE) ->
        start = page * page_size
        end = start + page_size - 1
        (r) -> r.setRequestHeader 'Range', "items=#{ start }-#{ end }"

    # Normalize ajax error handling.
    ajaxError = (handler) ->
        (xhr) ->
            try
                error = ($.parseJSON xhr.responseText).error
            catch e
                if xhr.status == 503
                    error =
                        code: 'maintenance',
                        message: 'The server is currently undergoing maintenance'
                else
                    error =
                        code: 'response_error',
                        message: "Unable to parse server response (status: #{xhr.status} #{xhr.statusText})"
                    console.log 'Unable to parse server response'
                    console.log xhr.responseText
            handler? error.code, error.message

    class Api
        constructor: (@root) ->

        init: ({success, error}) =>
            @request @root,
                error: error
                success: (r) =>
                    if r.root.status != 'ok'
                        error? 'response_error', 'Unexpected response from server'
                        return
                    @uris =
                        root: @root
                        authentication: r.root.authentication.uri
                        genome: r.root.genome.uri
                        annotations: r.root.annotation_collection.uri
                        coverages: r.root.coverage_collection.uri
                        data_sources: r.root.data_source_collection.uri
                        samples: r.root.sample_collection.uri
                        tokens: r.root.token_collection.uri
                        users: r.root.user_collection.uri
                        variants: r.root.variant_collection.uri
                        variations: r.root.variation_collection.uri
                    success?()

        annotation: (uri, options={}) =>
            uri += '?embed=original_data_source,annotated_data_source'  # Todo: Proper URI construction.
            success = options.success
            options.success = (data) -> success? data.annotation
            @request uri, options

        annotations: (options={}) =>
            uri = @uris.annotations + '?embed=original_data_source,annotated_data_source'
            if options.filter == 'own'
                uri += "&annotated_data_source.user=#{ encodeURIComponent @current_user?.uri }"
            @collection uri, 'annotation', options

        create_annotation: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.annotation
            options.method = 'POST'
            @request @uris.annotations, options

        authenticate: (@login, @password, {success, error}) =>
            @current_user = null
            @request @uris.authentication,
                success: (r) =>
                    if r.authentication.authenticated
                        @current_user = r.authentication.user
                        success?()
                    else
                        error? 'authentication_error',
                            "Unable to authenticate with login '#{login}' and password '***'"
                error: error

        coverages: (options={}) =>
            uri = @uris.coverages + '?embed=data_source'
            if options.sample?
                uri += "&sample=#{ encodeURIComponent options.sample }"
            @collection uri, 'coverage', options

        data_source: (uri, options={}) =>
            uri += '?embed=user'  # Todo: Proper URI construction.
            success = options.success
            options.success = (data) -> success? data.data_source
            @request uri, options

        data_sources: (options={}) =>
            uri = @uris.data_sources
            if options.filter == 'own'
                uri += "?user=#{ encodeURIComponent @current_user?.uri }"
            @collection uri, 'data_source', options

        create_data_source: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.data_source
            options.method = 'POST'
            @request @uris.data_sources, options

        edit_data_source: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.data_source
            options.method = 'PATCH'
            @request uri, options

        delete_data_source: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success?()
            options.method = 'DELETE'
            @request uri, options

        genome: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.genome
            @request @uris.genome, options

        sample: (uri, options={}) =>
            uri += '?embed=user'  # Todo: Proper URI construction.
            success = options.success
            options.success = (data) -> success? data.sample
            @request uri, options

        samples: (options={}) =>
            uri = @uris.samples
            if options.filter == 'own'
                uri += "?user=#{ encodeURIComponent @current_user?.uri }"
            if options.filter == 'public'
                uri += '?public=true'
            @collection uri, 'sample', options

        create_sample: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.sample
            options.method = 'POST'
            @request @uris.samples, options

        edit_sample: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.sample
            options.method = 'PATCH'
            @request uri, options

        delete_sample: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success?()
            options.method = 'DELETE'
            @request uri, options

        token: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.token
            @request uri, options

        tokens: (options={}) =>
            uri = @uris.tokens
            if options.filter == 'own'
                uri += "?user=#{ encodeURIComponent @current_user?.uri }"
            @collection uri, 'token', options

        create_token: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.token
            options.method = 'POST'
            @request @uris.tokens, options

        edit_token: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.token
            options.method = 'PATCH'
            @request uri, options

        delete_token: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success?()
            options.method = 'DELETE'
            @request uri, options

        user: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.user
            @request uri, options

        users: (options={}) =>
            @collection @uris.users, 'user', options

        create_user: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.user
            options.method = 'POST'
            @request @uris.users, options

        edit_user: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.user
            options.method = 'PATCH'
            @request uri, options

        delete_user: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success?()
            options.method = 'DELETE'
            @request uri, options

        variations: (options={}) =>
            uri = @uris.variations + '?embed=data_source'
            if options.sample?
                uri += "&sample=#{ encodeURIComponent options.sample }"
            @collection uri, 'variation', options

        variant: (uri, options={}) =>
            success = options.success
            options.success = (data) -> success? data.variant
            @request uri, options

        variants: (options={}) =>
            uri = @uris.variants
            region = "chromosome:#{ options.region.chromosome }"
            region += ",begin:#{ options.region.begin }"
            region += ",end:#{ options.region.end }"
            uri += "?region=#{ encodeURIComponent region }"
            if options.sample
                uri += "&sample=#{ encodeURIComponent options.sample }"
            @collection uri, 'variant', options

        create_variant: (options={}) =>
            success = options.success
            options.success = (data) -> success? data.variant
            options.method = 'POST'
            @request @uris.variants, options

        collection: (uri, type, options={}) =>
            options.page_number ?= 0
            options.page_size ?= config.PAGE_SIZE
            @request uri,
                beforeSend: addRangeForPage options.page_number, config.PAGE_SIZE
                success: (data, status, xhr) ->
                    range = xhr.getResponseHeader 'Content-Range'
                    total = parseInt (range.split '/')[1]
                    pagination =
                        total: Math.ceil total / options.page_size
                        current: options.page_number
                    options.success? data["#{ type }_collection"].items, pagination
                error: (code, message) ->
                    if code == 'unsatisfiable_range'
                        options.success? [], total: 0, current: 0
                    else
                        options.error? code, message
                data: options.data

        request: (uri, options={}) =>
            $.ajax uri,
                beforeSend: (r) =>
                    addAuth r, @login, @password
                    addVersion r
                    options.beforeSend? r
                data: options.data
                success: options.success
                error: ajaxError options.error
                dataType: 'json'
                type: options.method ? 'GET'
            return
