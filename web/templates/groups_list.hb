{{#if groups}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th></tr></thead>
    <tbody>
      {{#each groups}}
      <tr data-href="{{../base}}/groups/{{escape uri}}">
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No groups are here.</p>
{{/if}}
