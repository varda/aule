{{#title}}Data sources{{/title}}

<ul class="nav nav-pills">
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}}active{{/if_eq}}{{/if_eq}}{{#if auth.rights.list_data_sources}}{{else}} disabled{{/if}}">
    <a href="{{base}}/data_sources"><i class="icon-th"></i> All data sources</a>
  </li>
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}{{#if auth}}{{else}} disabled{{/if}}">
    <a href="{{base}}/data_sources?filter=own"><i class="icon-th-large"></i> My data sources</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}{{#if auth.rights.add_data_source}}{{else}} disabled{{/if}}">
    <a href="{{base}}/data_sources_add"><i class="icon-plus"></i> Add data source</a>
  </li>
</ul>

{{> subpage}}
