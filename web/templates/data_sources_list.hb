{{#if data_sources}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Name</th></tr></thead>
    <tbody>
      {{#each data_sources}}
      <tr data-href="/varda-web/data_sources/{{escape uri}}">
        <td>{{added}}</td>
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No data sources are here.</p>
{{/if}}
