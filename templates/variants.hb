{{#title}}Variants{{/title}}

<p>Query:
{{#equals query 'global'}}
global
{{/equals}}
{{#equals query 'sample'}}
<a href="{{uri base 'samples' sample.uri}}">{{sample.name}}</a>
{{/equals}}
{{#equals query 'group'}}
<a href="{{uri base 'group' group.uri}}">{{group.name}}</a>
{{/equals}}
{{#equals query 'custom'}}
<code>{{custom}}</code>
{{/equals}}
</p>

{{#if region}}
<p>Chromosome: {{region.chromosome}}</p>
<p>Region begin: {{region.begin}}</p>
<p>Region end: {{region.end}}</p>
{{/if}}

{{#if variants}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Chromosome</th><th class="cell-numeric">Position</th><th>Reference</th><th>Observed</th><th class="cell-numeric">Frequency</th><th class="cell-numeric">N</th></tr></thead>
    <tbody>
      {{#each variants}}
      <tr data-href="{{uri ../base 'variants' ./uri query=../query sample=../sample.uri group=../group.uri custom=../custom}}">
        <td>{{chromosome}}</td>
        <td class="cell-numeric">{{position}}</td>
        <td>{{reference}}</td>
        <td>{{observed}}</td>
        <td class="cell-numeric">{{number frequency decimals=4}}</td>
        <td class="cell-numeric">{{coverage}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No variants are here.</p>
{{/if}}
