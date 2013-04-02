Aulë
====

A web interface to the Varda database for genomic variation frequencies.

**Warning:** This is a work in progress, probably not yet ready for use!


Description
-----------

Aulë is a client-side JavaScript-driven interface to the Varda REST
server. The HTML5 layout is based on Twitter's
[Bootstrap](http://twitter.github.com/bootstrap/) and uses
[Less](http://lesscss.org/) stylesheets. The interface is implemented in
[Coffeescript](http://coffeescript.org/) using the
[Sammy.js](http://sammyjs.org/) framework.

At the moment, both the Less stylesheets and the CoffeeScript files are
compiled dynamically in the browser to CSS and JavaScript, respectively. In
the future, we could pre-compile them. Same goes for the
[Mustache](http://mustache.github.com/) templates, we could for example use
[Hogan.js](http://twitter.github.com/hogan.js/) for compiled templates.


Webserver configuration
-----------------------

By the same-origin-policy, the web client must be served from the same domain
as the REST server.

Example nginx configuration:

    upstream varda {
        server 127.0.0.1:5000;
    }

    server {
        listen 8181;
        server_name celly;
        location / {
            root /home/martijn/projects/aule/web;
            try_files $uri /index.html;
        }
        location /api/v1/ {
            proxy_pass http://varda/;
        }

    }

Another option is to have Varda itself serve Aulë by setting `AULE_LOCAL_PATH`
in the Varda configuration.


Documentation
-------------

Todo (surprise, surprise).


Copyright
---------

Manwë is licensed under the MIT License, see the LICENSE file for details. See
the AUTHORS file for a list of authors.
