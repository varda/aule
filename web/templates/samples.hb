{{#title}}Samples{{/title}}

{{#if auth}}
  <ul class="nav nav-pills">
{{/if}}

{{#if auth.rights.list_samples}}
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/samples"><i class="icon-th"></i> All samples</a>
  </li>
{{/if}}

{{#if auth}}
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="public"}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/samples?filter=public"><i class="icon-th-large"></i> Puplic samples</a>
  </li>
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/samples?filter=own"><i class="icon-th-large"></i> My samples</a>
  </li>
{{/if}}

{{#if auth.rights.add_sample}}
  <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}">
    <a href="{{base}}/samples_add"><i class="icon-plus"></i> Add sample</a>
  </li>
{{/if}}

{{#if auth}}
  </ul>
{{/if}}

{{> subpage}}
