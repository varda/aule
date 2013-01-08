<ul class="nav nav-pills">
  {{#if auth.rights.list_samples}}
    <li{{#if_eq current compare="samples"}} class="active"{{/if_eq}}><a href="/varda-web/samples"><i class="icon-th"></i> All samples</a></li>
  {{/if}}
  <li{{#if_eq current compare="samples_public"}} class="active"{{/if_eq}}><a href="/varda-web/samples_public"><i class="icon-th-large"></i> Puplic samples</a></li>
  {{#if auth}}
    <li{{#if_eq current compare="samples_own"}} class="active"{{/if_eq}}><a href="/varda-web/samples_own"><i class="icon-th-large"></i> My samples</a></li>
  {{/if}}
  {{#if auth.rights.add_sample}}
    <li class="{{#if_eq current compare="samples_add"}}active {{/if_eq}}pull-right"><a href="/varda-web/samples_add"><i class="icon-plus"></i> Add sample</a></li>
  {{/if}}
</ul>

{{> page}}
