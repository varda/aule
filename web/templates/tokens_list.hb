{{#if tokens}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Name</th></tr></thead>
    <tbody>
      {{#each tokens}}
      <tr data-href="{{../base}}/tokens/{{escape uri}}">
        <td>{{dateFormat added}}</td>
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No API tokens are here.</p>
{{/if}}
