{{#title}}{{variant.chromosome}}:{{variant.position}}{{/title}}

<dl class="dl-horizontal">
  <dt>Query</dt>
  <dd>
    {{#if_eq query compare="global"}}
    Global query
    {{/if_eq}}
    {{#if_eq query compare="sample"}}
    Sample query: <a href="{{base}}/samples/{{escape sample.uri}}">{{sample.name}}</a>
    {{/if_eq}}
    {{#if_eq query compare="group"}}
    Group query: <a href="{{base}}/group/{{escape group.uri}}">{{group.name}}</a>
    {{/if_eq}}
    {{#if_eq query compare="custom"}}
    Custom query: <code>{{custom}}</code>
    {{/if_eq}}
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
  <dd>{{numberFormat variant.frequency decimals=4}} ({{numberFormat variant.frequency_het decimals=4}} heterozygous, {{numberFormat variant.frequency_hom decimals=4}} homozygous)</dd>
  <dt>URI</dt>
  <dd>{{variant.uri}}</dd>
</dl>
