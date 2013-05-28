<dl class="dl-horizontal">
  <dt>Name</dt>
  <dd>{{sample.name}}</dd>
  <dt>Active</dt>
  <dd>{{#if sample.active}}Yes{{else}}No{{/if}}</dd>
  <dt>Public</dt>
  <dd>{{#if sample.public}}Yes{{else}}No{{/if}}</dd>
  <dt>Pool size</dt>
  <dd>{{sample.pool_size}}</dd>
{{#if sample.notes}}
  <dt>Notes</dt>
  <dd>{{sample.notes}}</dd>
{{/if}}
  <dt>Added</dd>
  <dd>{{dateFormat sample.added}}</dd>
  <dt>User</dt>
  <dd><a href="/users/{{escape sample.user.uri}}">{{sample.user.uri}}</a></dd>
  <dt>URI</dt>
  <dd>{{sample.uri}}</dd>
</dl>
