{{#if users}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Login</th><th>Name</th><th>Roles</th></tr></thead>
    <tbody>
      {{#each users}}
      <tr data-href="/varda-web/users/{{escape uri}}">
        <td>{{added}}</td>
        <td>{{login}}</td>
        <td>{{name}}</td>
        <td>{{roles}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No users are here.</p>
{{/if}}
