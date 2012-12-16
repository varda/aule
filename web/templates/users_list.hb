{{#if users}}
  {{#if pages}}
    <div class="pagination pagination-centered">
      <ul>
        {{#if pages.prev}}
          <li><a href="?page={{pages.prev.page}}">←</a></li>
        {{else}}
          <li class="disabled"><a>←</a></li>
        {{/if}}
        {{#each pages}}
          <li{{#if active}} class="active"{{/if}}><a href="?page={{page}}">{{label}}</a></li>
        {{/each}}
        {{#if pages.next}}
          <li><a href="?page={{pages.next.page}}">→</a></li>
        {{else}}
          <li class="disabled"><a>→</a></li>
        {{/if}}
      </ul>
    </div>
  {{/if}}
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
  {{#if pages}}
    <div class="pagination pagination-centered">
      <ul>
        {{#if pages.prev}}
          <li><a href="?page={{pages.prev.page}}">←</a></li>
        {{else}}
          <li class="disabled"><a>←</a></li>
        {{/if}}
        {{#each pages}}
          <li{{#if active}} class="active"{{/if}}><a href="?page={{page}}">{{label}}</a></li>
        {{/each}}
        {{#if pages.next}}
          <li><a href="?page={{pages.next.page}}">→</a></li>
        {{else}}
          <li class="disabled"><a>→</a></li>
        {{/if}}
      </ul>
    </div>
  {{/if}}
{{else}}
  <p>No users are here.</p>
{{/if}}
