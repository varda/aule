{{#if samples}}
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Name</th></tr></thead>
    <tbody>
      {{#each samples}}
      <tr data-href="/varda-web/samples/{{escape uri}}">
        <td>{{added}}</td>
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
{{else}}
  <p>No samples are here.</p>
{{/if}}
