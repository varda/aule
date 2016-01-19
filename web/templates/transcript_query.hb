{{#if transcripts}}
  <table class="table table-hover">
    <thead><tr><th>Gene</th><th>Transcript</th></tr></thead>
    <tbody>
      {{#each transcripts}}
      <tr data-value="{{entrezgene}}/{{refseq}}" data-name="{{refseq}} ({{symbol}})">
        <td>{{symbol}} ({{name}})</td>
        <td>{{refseq}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{#if incomplete}}
    <p>Not all hits are shown, try refining your search query.</p>
  {{/if}}
{{else}}
  <p>No transcripts are here.</p>
{{/if}}
