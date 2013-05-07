# Aulë
#
# A web interface to the Varda database for genomic variation frequencies.
#
# Martijn Vermaat <m.vermaat.hg@lumc.nl>
#
# Licensed under the MIT license, see the LICENSE file.


define ->

    # Prefix for resources such as templates.
    RESOURCES_PREFIX: '/aule'

    # Root endpoint of Varda server.
    API_ROOT: '/'

    # Number of items per page.
    PAGE_SIZE: 50

    # Number of pages to be considered many by the UI.
    MANY_PAGES: 13
