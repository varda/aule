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
  <dd>{{variant.frequency}} ({{variant.frequency_het}} heterozygous, {{variant.frequency_hom}} homozygous)</dd>
  <dt>URI</dt>
  <dd>{{variant.uri}}</dd>
</dl>
