/*
Aulë

A web interface to the Varda database for genomic variation frequencies.

Martijn Vermaat <m.vermaat.hg@lumc.nl>

Licensed under the MIT license, see the LICENSE file.
*/


requirejs.config({
    shim: {
        'bootstrap-alert': ['jquery'],
        'bootstrap-collapse': ['jquery'],
        'bootstrap-modal': ['jquery'],
        'bootstrap-transition': ['jquery'],
        'handlebars': {
            exports: 'Handlebars'
        },
        'jquery.base64': ['jquery']
    }
});


require({
    paths: {
        'bootstrap-alert': '../bootstrap/js/bootstrap-alert',
        'bootstrap-collapse': '../bootstrap/js/bootstrap-collapse',
        'bootstrap-modal': '../bootstrap/js/bootstrap-modal',
        'bootstrap-transition': '../bootstrap/js/bootstrap-transition',
        'cs': 'vendor/cs',
        'coffee-script': 'vendor/coffee-script',
        'handlebars': 'vendor/handlebars',
        'jquery': 'vendor/jquery',
        'jquery.base64': 'vendor/jquery.base64',
        'less': 'vendor/less',
        'sammy': '../sammy/sammy',
        'sammy.handlebars': '../sammy/plugins/sammy.handlebars'
    }
}, ['jquery', 'less', 'bootstrap-alert', 'bootstrap-collapse', 'bootstrap-modal', 'bootstrap-transition', 'cs!init']);
