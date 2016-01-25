{{#title}}{{variant.chromosome}}:{{variant.position}}{{/title}}

<dl class="dl-horizontal">
  <dt>Query</dt>
  <dd>
    {{#equals query 'global'}}
    Global query
    {{/equals}}
    {{#equals query 'sample'}}
    Sample query: <a href="{{uri base 'samples' sample.uri}}">{{sample.name}}</a>
    {{/equals}}
    {{#equals query 'group'}}
    Group query: <a href="{{uri base 'group' group.uri}}">{{group.name}}</a>
    {{/equals}}
    {{#equals query 'custom'}}
    Custom query: <code>{{custom}}</code>
    {{/equals}}
  </dd>
  <dt>Chromosome</dt>
  <dd>{{variant.chromosome}}</dd>
  <dt>Position</dt>
  <dd>{{variant.position}}</dd>
  <dt>Reference sequence</dt>
  <dd>{{#if variant.reference}}{{variant.reference}}{{else}}(none){{/if}}</dd>
  <dt>Observed sequence</dt>
  <dd>{{#if variant.observed}}{{variant.observed}}{{else}}(none){{/if}}</dd>
  <dt>Coverage</dt>
  <dd>{{variant.coverage}} individuals</dd>
  <dt>Frequency</dt>
  <dd>{{number variant.frequency decimals=4}} ({{number variant.frequency_het decimals=4}} heterozygous, {{number variant.frequency_hom decimals=4}} homozygous)</dd>
  <dt>URI</dt>
  <dd>{{variant.uri}}</dd>
</dl>
