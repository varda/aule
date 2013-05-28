{{#if users}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th><th>Login</th><th>Roles</th><th>Added</th></tr></thead>
    <tbody>
      {{#each users}}
      <tr data-href="{{../base}}/users/{{escape uri}}">
        <td>{{name}}</td>
        <td>{{login}}</td>
        <td>{{roles}}</td>
        <td>{{dateFormat added}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No users are here.</p>
{{/if}}
