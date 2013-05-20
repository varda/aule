{{#title}}Data sources{{/title}}

{{#if auth.rights.list_data_sources}}
  <ul class="nav nav-pills">
{{else}}
  {{#if auth.rights.add_data_source}}
    <ul class="nav nav-pills">
  {{/if}}
{{/if}}

{{#if auth.rights.list_data_sources}}
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/data_sources"><i class="icon-th"></i> All data sources</a>
  </li>
{{/if}}

{{#if auth.rights.list_data_sources}}
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/data_sources?filter=own"><i class="icon-th-large"></i> My data sources</a>
  </li>
{{else}}
  {{#if auth.rights.add_data_source}}
    <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}">
      <a href="{{base}}/data_sources?filter=own"><i class="icon-th-large"></i> My data sources</a>
    </li>
  {{/if}}
{{/if}}

{{#if auth.rights.add_data_source}}
  <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}">
    <a href="{{base}}/data_sources_add"><i class="icon-plus"></i> Add data source</a>
  </li>
{{/if}}

{{#if auth.rights.list_data_sources}}
  </ul>
{{else}}
  {{#if auth.rights.add_data_source}}
    </ul>
  {{/if}}
{{/if}}

{{> subpage}}
