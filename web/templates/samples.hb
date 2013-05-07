{{#title}}Samples{{/title}}

<ul class="nav nav-pills">
  {{#if auth.rights.list_samples}}
    <li{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}} class="active"{{/if_eq}}{{/if_eq}}><a href="{{base}}/samples"><i class="icon-th"></i> All samples</a></li>
  {{/if}}
  <li{{#if_eq subpage compare="list"}}{{#if_eq filter compare="public"}} class="active"{{/if_eq}}{{/if_eq}}><a href="{{base}}/samples?filter=public"><i class="icon-th-large"></i> Puplic samples</a></li>
  {{#if auth}}
    <li{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}} class="active"{{/if_eq}}{{/if_eq}}><a href="{{base}}/samples?filter=own"><i class="icon-th-large"></i> My samples</a></li>
  {{/if}}
  {{#if auth.rights.add_sample}}
    <li class="{{#if_eq subpage compare="add"}}active {{/if_eq}}pull-right"><a href="{{base}}/samples_add"><i class="icon-plus"></i> Add sample</a></li>
  {{/if}}
</ul>

{{> subpage}}
