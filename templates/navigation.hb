<div class="sidebar-nav">
  <ul class="nav nav-list">
    <li class="nav-header">Resources</li>
    {{#if auth.rights.list_samples}}
      <li><a href="{{uri base 'samples'}}">Samples</a></li>
    {{else}}
      {{#if auth}}
        <li><a href="{{uri base 'samples' filter='own'}}">Samples</a></li>
      {{else}}
        <li><a href="{{uri base 'samples' filter='public'}}">Samples</a></li>
      {{/if}}
    {{/if}}
    <li><a href="{{uri base 'groups'}}">Groups</a></li>
    {{#if auth.rights.list_data_sources}}
      <li><a href="{{uri base 'data_sources'}}">Data sources</a></li>
    {{else}}
      {{#if auth}}
        <li><a href="{{uri base 'data_sources' filter='own'}}">Data sources</a></li>
      {{/if}}
    {{/if}}
    {{#if auth.rights.list_annotations}}
      <li><a href="{{uri base 'annotations'}}">Annotations</a></li>
    {{else}}
      {{#if auth}}
        <li><a href="{{uri base 'annotations' filter='own'}}">Annotations</a></li>
      {{/if}}
    {{/if}}
    {{#if auth.rights.list_users}}
      <li><a href="{{uri base 'users'}}">Users</a></li>
    {{/if}}
    <li class="nav-header">Frequency lookup</li>
    <li><a href="{{uri base 'lookup_variant'}}">By variant</a></li>
    <li><a href="{{uri base 'lookup_region'}}">By region</a></li>
    {{#if query_by_transcript }}
      <li><a href="{{uri base 'lookup_transcript'}}">By transcript</a></li>
    {{/if}}
    {{#if auth}}
      <li class="nav-header">Account</li>
      <li><a href="{{uri base 'users' auth.user.uri}}">User profile</a></li>
      <li><a href="{{uri base 'tokens'}}">API tokens</a></li>
    {{/if}}
  </ul>
</div>
