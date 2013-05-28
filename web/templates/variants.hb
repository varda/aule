{{#title}}Variants{{/title}}

{{#if variants}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Chromosome</th><th class="cell-numeric">Position</th><th>Reference</th><th>Observed</th><th class="cell-numeric">Frequency</th><th class="cell-numeric">N</th></tr></thead>
    <tbody>
      {{#each variants}}
      <tr data-href="{{../base}}/variants/{{escape uri}}?sample={{escape ../sample.uri}}">
        <td>{{chromosome}}</td>
        <td class="cell-numeric">{{position}}</td>
        <td>{{reference}}</td>
        <td>{{observed}}</td>
        <td class="cell-numeric">{{numberFormat frequency decimals=4}}</td>
        <td class="cell-numeric">{{coverage}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No variants are here.</p>
{{/if}}
