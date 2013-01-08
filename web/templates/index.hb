<p>This is the index page.</p>

{{#if auth}}
  <p>Logged in as {{auth.name}}.</p>
{{else}}
  <p>Not logged in.</p>
{{/if}}
