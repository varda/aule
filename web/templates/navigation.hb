<div class="sidebar-nav">
  <ul class="nav nav-list">
    <li class="nav-header">Samples</li>
    {{#if auth.rights.list_samples}}
      <li><a href="{{base}}/samples">All samples</a></li>
    {{/if}}
    <li><a href="{{base}}/samples?filter=public">Public samples</a></li>
    {{#if auth}}
      <li><a href="{{base}}/samples?filter=own">My samples</a></li>
    {{/if}}
    {{#if auth}}
      <li class="nav-header">Data sources</li>
    {{/if}}
    {{#if auth.rights.list_data_sources}}
      <li><a href="{{base}}/data_sources">All data sources</a></li>
    {{/if}}
    {{#if auth}}
      <li><a href="{{base}}/data_sources?filter=own">My data sources</a></li>
    {{/if}}
    {{#if auth.rights.list_users}}
      <li class="nav-header">Users</li>
      <li><a href="{{base}}/users">All users</a></li>
    {{/if}}
    <li class="nav-header">Variants</li>
    <li><a href="{{base}}/lookup_variant">Lookup variant</a></li>
    <li><a href="{{base}}/lookup_region">Lookup region</a></li>
  </ul>
</div>
