{{#title}}Data sources{{/title}}

<ul class="nav nav-pills">
  {{#if auth.rights.list_data_sources}}
    <li{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}} class="active"{{/if_eq}}{{/if_eq}}><a href="{{base}}/data_sources"><i class="icon-th"></i> All data sources</a></li>
  {{/if}}
  <li{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}} class="active"{{/if_eq}}{{/if_eq}}><a href="{{base}}/data_sources?filter=own"><i class="icon-th-large"></i> My data sources</a></li>
  {{#if auth.rights.add_data_source}}
    <li class="{{#if_eq subpage compare="add"}}active {{/if_eq}}pull-right"><a href="{{base}}/data_sources_add"><i class="icon-plus"></i> Add data source</a></li>
  {{/if}}
</ul>

{{> subpage}}
