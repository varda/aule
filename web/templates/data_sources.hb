<ul class="nav nav-pills">
  <li{{#if_eq current compare="data_sources_own"}} class="active"{{/if_eq}}><a href="/varda-web/data_sources_own"><i class="icon-th-large"></i> My data sources</a></li>
  <li{{#if_eq current compare="data_sources"}} class="active"{{/if_eq}}><a href="/varda-web/data_sources"><i class="icon-th"></i> All data sources</a></li>
  <li class="{{#if_eq current compare="data_sources_add"}}active {{/if_eq}}pull-right"><a href="/varda-web/data_sources_add"><i class="icon-plus"></i> Add data source</a></li>
</ul>

{{> page}}
