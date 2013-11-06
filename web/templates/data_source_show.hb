<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Name</th>
      <td>{{data_source.name}}</td>
    </tr>
    <tr>
      <th scope="row">User</th>
      <td><a href="{{base}}/users/{{escape data_source.user.uri}}">{{data_source.user.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Filetype</th>
      <td>{{data_source.filetype}}{{#if data_source.gzipped}} (compressed){{/if}}</td>
    </tr>
    <tr>
      <th scope="row">Added</th>
      <td>{{dateFormat data_source.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{data_source.uri}}</td>
    </tr>
  </tbody>
</table>

<p>Use <a href="http://curl.haxx.se/"><code>curl</code></a> and an <a href="{{base}}/tokens">API token</a> to download this data source to your computer:</p>

<pre>
curl -H 'Authorization: Token &lt;API token&gt;' 'https://&lt;domain&gt;{{data_source.data.uri}}' &gt; data.{{data_source.filetype}}{{#if data_source.gzipped}}.gz{{/if}}
</pre>
