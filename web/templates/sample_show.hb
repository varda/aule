<dl class="dl-horizontal">
  <dt>Name</dt>
  <dd>{{sample.name}}</dd>
  <dt>User</dt>
  <dd><a href="/users/{{escape sample.user.uri}}">{{sample.user.name}}</a></dd>
  <dt>Active</dt>
  <dd>{{#if sample.active}}Yes{{else}}No{{/if}}</dd>
  <dt>Public</dt>
  <dd>{{#if sample.public}}Yes{{else}}No{{/if}}</dd>
  <dt>Pool size</dt>
  <dd>{{sample.pool_size}}</dd>
  <dt>Added</dd>
  <dd>{{dateFormat sample.added}}</dd>
  <dt>URI</dt>
  <dd>{{sample.uri}}</dd>
</dl>

{{#if sample.notes}}
<h2>Notes</h2>
<div id="sample-notes"><pre>{{sample.notes}}</pre></div>
<script>
// Note: An alternative for the `marked` module could be `PageDown`.
require(['jquery', 'marked'], function($, marked) {
    // We don't actually have to sanitize, since Handlebars already did it
    // for us.
    //marked.setOptions({sanitize: true});
    var notes = marked($('#sample-notes pre').html());
    $('#sample-notes').html(notes);
});
</script>
{{/if}}
