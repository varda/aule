<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Name</th>
      <td>{{user.name}}</td>
    </tr>
    <tr>
      <th scope="row">Login</th>
      <td>{{user.login}}</td>
    </tr>
    {{#if user.email}}
    <tr>
      <th scope="row">Email</th>
      <td><a href="mailto:{{user.email}}">{{user.email}}</a></td>
    </tr>
    {{/if}}
    <tr>
      <th scope="row">Roles</th>
      <td>
      {{#if user.roles}}
        {{#each user.roles}}
          {{this}}{{#unless @last}}, {{/unless}}
        {{/each}}
      {{else}}
        None
      {{/if}}
      </td>
    </tr>
    <tr>
      <th scope="row">Added</th>
      <td>{{dateFormat user.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{user.uri}}</td>
    </tr>
  </tbody>
</table>
