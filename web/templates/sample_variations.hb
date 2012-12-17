{{#if variations}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>URI</th><th>Imported</th></tr></thead>
    <tbody>
      {{#each variations}}
      <tr>
        <td>{{uri}}</td>
        <td>{{imported}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No variations are here.</p>
{{/if}}
