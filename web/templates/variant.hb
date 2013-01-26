<dl class="dl-horizontal">
  <dt>Chromosome</dt>
  <dd>{{variant.chromosome}}</dd>
  <dt>Position</dt>
  <dd>{{variant.position}}</dd>
  <dt>Reference sequence</dt>
  <dd>{{#if variant.reference}}{{variant.reference}}{{else}}(none){{/if}}</dd>
  <dt>Observed sequence</dt>
  <dd>{{#if variant.observed}}{{variant.observed}}{{else}}(none){{/if}}</dd>
  <dt>HGVS description</dt>
  <dd>{{variant.hgvs}}</dd>
  <dt>Frequency</dt>
  <dd>{{variant.frequency}}</dd>
  <dt>URI</dt>
  <dd>{{variant.uri}}</dd>
</dl>
