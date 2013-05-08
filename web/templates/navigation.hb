<div class="sidebar-nav">
  <ul class="nav nav-list">
    <li class="nav-header">Samples</li>
    {{#if auth.rights.list_samples}}
      <li><a href="/aule/samples">All samples</a></li>
    {{/if}}
    <li><a href="/aule/samples?filter=public">Public samples</a></li>
    {{#if auth}}
      <li><a href="/aule/samples?filter=own">My samples</a></li>
    {{/if}}
    {{#if auth}}
      <li class="nav-header">Data sources</li>
    {{/if}}
    {{#if auth.rights.list_data_sources}}
      <li><a href="/aule/data_sources">All data sources</a></li>
    {{/if}}
    {{#if auth}}
      <li><a href="/aule/data_sources?filter=own">My data sources</a></li>
    {{/if}}
    {{#if auth.rights.list_users}}
      <li class="nav-header">Users</li>
      <li><a href="/aule/users">All users</a></li>
    {{/if}}
    <li class="nav-header">Variants</li>
    <li><a href="/aule/variants_variant">Lookup variant</a></li>
    <li><a href="/aule/variants_region">Lookup region</a></li>
  </ul>
</div>
