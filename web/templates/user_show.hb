<dl class="dl-horizontal">
  <dt>Name</dt>
  <dd>{{user.name}}</dt>
  <dt>Login</dt>
  <dd>{{user.login}}</dd>
{{#if user.email}}
  <dt>Email</dt>
  <dd><a href="mailto:{{user.email}}">{{user.email}}</a></dd>
{{/if}}
  <dt>Roles</dt>
  <dd>{{user.roles}}</dd>
  <dt>Added</dt>
  <dd>{{dateFormat user.added}}</dd>
  <dt>URI</dt>
  <dd>{{user.uri}}</dd>
</dl>
