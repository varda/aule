{{#title}}Variants{{/title}}

<p>Query:
{{#if_eq query compare="global"}}
global
{{/if_eq}}
{{#if_eq query compare="sample"}}
<a href="{{base}}/samples/{{escape sample.uri}}">{{sample.name}}</a>
{{/if_eq}}
{{#if_eq query compare="group"}}
<a href="{{base}}/group/{{escape group.uri}}">{{group.name}}</a>
{{/if_eq}}
{{#if_eq query compare="custom"}}
<code>{{custom}}</code>
{{/if_eq}}
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
      <tr data-href="{{../base}}/variants/{{escape uri}}?query={{escape ../query}}&sample={{escape ../sample.uri}}&group={{escape ../group.uri}}&custom={{escape ../custom}}">
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
