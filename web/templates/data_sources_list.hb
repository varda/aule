{{#if data_sources}}
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Name</th><th>Filetype</th></tr></thead>
    <tbody>
      {{#each data_sources}}
      <tr data-href="/varda-web/data_sources/{{escape uri}}">
        <td>{{added}}</a></td>
        <td>{{name}}</td>
        <td>{{filetype}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
{{else}}
  <p>No data sources here.</p>
{{/if}}
