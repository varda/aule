{{#if variations}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Data source</th><th>Imported</th></tr></thead>
    <tbody>
      {{#each variations}}
      <tr>
        <td>{{data_source.name}}</td>
        <td>{{#if imported}}<i class="icon-ok"></i>{{/if}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No observations are here.</p>
{{/if}}
