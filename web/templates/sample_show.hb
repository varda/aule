<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Name</th>
      <td>{{sample.name}}</td>
    </tr>
    <tr>
      <th scope="row">User</th>
      <td><a href="{{base}}/users/{{escape sample.user.uri}}">{{sample.user.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Active</th>
      <td>{{#if sample.active}}Yes{{else}}No{{/if}}</td>
    </tr>
    <tr>
      <th scope="row">Public</th>
      <td>{{#if sample.public}}Yes{{else}}No{{/if}}</td>
    </tr>
    <tr>
      <th scope="row">Pool size</th>
      <td>{{sample.pool_size}}</td>
    </tr>
    <tr>
      <th scope="row">Added</th>
      <td>{{dateFormat sample.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{sample.uri}}</td>
    </tr>
  </tbody>
</table>

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
