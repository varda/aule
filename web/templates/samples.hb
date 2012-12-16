<ul class="nav nav-pills">
  <li{{#if_eq tab compare="samples_own"}} class="active"{{/if_eq}}><a href="/varda-web/samples_own"><i class="icon-th-large"></i> My samples</a></li>
  <li{{#if_eq tab compare="samples_public"}} class="active"{{/if_eq}}><a href="/varda-web/samples_public"><i class="icon-th-large"></i> Puplic samples</a></li>
  <li{{#if_eq tab compare="samples"}} class="active"{{/if_eq}}><a href="/varda-web/samples"><i class="icon-th"></i> All samples</a></li>
  <li class="{{#if_eq tab compare="add_sample"}}active {{/if_eq}}pull-right"><a href="/varda-web/add_sample"><i class="icon-plus"></i> Add sample</a></li>
</ul>

{{> page}}
