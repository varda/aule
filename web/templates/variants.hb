{{#title}}Variants{{/title}}

{{#if variants}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Chromosome</th><th>Position</th><th>Reference</th><th>Observed</th><th>Frequency</th></tr></thead>
    <tbody>
      {{#each variants}}
      <tr data-href="{{../base}}/variants/{{escape uri}}">
        <td>{{chromosome}}</td>
        <td>{{position}}</td>
        <td>{{reference}}</td>
        <td>{{observed}}</td>
        <td>{{frequency}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No variants are here.</p>
{{/if}}
