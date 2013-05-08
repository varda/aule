{{#title}}Samples{{/title}}

<ul class="nav nav-pills">
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}}active{{/if_eq}}{{/if_eq}}{{#if auth.rights.list_samples}}{{else}} disabled{{/if}}">
    <a href="{{base}}/samples"><i class="icon-th"></i> All samples</a>
  </li>
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="public"}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/samples?filter=public"><i class="icon-th-large"></i> Puplic samples</a>
  </li>
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}{{#if auth}}{{else}} disabled{{/if}}">
    <a href="{{base}}/samples?filter=own"><i class="icon-th-large"></i> My samples</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}{{#if auth.rights.add_sample}}{{else}} disabled{{/if}}">
    <a href="{{base}}/samples_add"><i class="icon-plus"></i> Add sample</a>
  </li>
</ul>

{{> subpage}}
