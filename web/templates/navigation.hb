<div class="sidebar-nav">
  <ul class="nav nav-list">
    <li class="nav-header">Resources</li>
    {{#if auth.rights.list_samples}}
      <li><a href="{{base}}/samples">Samples</a></li>
    {{else}}
      {{#if auth}}
        <li><a href="{{base}}/samples?filter=own">Samples</a></li>
      {{else}}
        <li><a href="{{base}}/samples?filter=public">Samples</a></li>
      {{/if}}
    {{/if}}
    {{#if auth.rights.list_data_sources}}
      <li><a href="{{base}}/data_sources">Data sources</a></li>
    {{else}}
      {{#if auth}}
        <li><a href="{{base}}/data_sources?filter=own">Data sources</a></li>
      {{/if}}
    {{/if}}
    {{#if auth.rights.list_users}}
      <li><a href="{{base}}/users">Users</a></li>
    {{/if}}
    <li class="nav-header">Frequency lookup</li>
    <li><a href="{{base}}/lookup_variant">By variant</a></li>
    <li><a href="{{base}}/lookup_region">By region</a></li>
    {{#if auth}}
      <li class="nav-header">Account</li>
      <li><a href="{{base}}/users/{{escape auth.user.uri}}">User profile</a></li>
      <li><a href="{{base}}/tokens">API tokens</a></li>
    {{/if}}
  </ul>
</div>
