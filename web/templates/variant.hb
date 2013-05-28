{{#title}}{{variant.chromosome}}:{{variant.position}}{{/title}}

<dl class="dl-horizontal">
  <dt>Sample</dt>
  <dd>{{#if variant.sample_uri}}{{variant.sample_uri}}{{else}}None (global){{/if}}</dd>
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
