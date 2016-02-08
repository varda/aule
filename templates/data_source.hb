{{#title}}{{data_source.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#equals subpage 'show'}}active{{/equals}}">
  <a href="{{uri base 'data_sources' data_source.uri}}"><i class="fa fa-file"></i> Data source</a>
</li>

{{#if auth.roles.admin}}
  <li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
    <a href="{{uri base 'data_sources' data_source.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit data source</a>
  </li>
  <li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
    <a href="{{uri base 'data_sources' data_source.uri 'delete'}}"><i class="fa fa-trash"></i> Delete data source</a>
  </li>
{{else}}
  {{#equals data_source.user.uri auth.user.uri}}
    <li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
      <a href="{{uri base 'data_sources' data_source.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit data source</a>
    </li>
    <li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
      <a href="{{uri base 'data_sources' data_source.uri 'delete'}}"><i class="fa fa-trash"></i> Delete data source</a>
    </li>
  {{/equals}}
{{/if}}

</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'delete'}}

<form action="{{uri base 'data_sources' data_source.uri 'delete'}}" method="post">
  <input type="hidden" name="name" id="name" value="{{data_source.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="fa fa-trash"></i> Delete data source</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'edit'}}

<form action="{{uri base 'data_sources' data_source.uri 'edit'}}" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">Data source name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{data_source.name}}">
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="fa fa-pencil"></i> Save changes</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'show'}}

<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Name</th>
      <td>{{data_source.name}}</td>
    </tr>
    <tr>
      <th scope="row">User</th>
      <td><a href="{{uri base 'users' data_source.user.uri}}">{{data_source.user.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Filetype</th>
      <td>{{data_source.filetype}}{{#if data_source.gzipped}} (compressed){{/if}}</td>
    </tr>
    <tr>
      <th scope="row">Added</th>
      <td>{{date data_source.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{data_source.uri}}</td>
    </tr>
  </tbody>
</table>

<p>Use <a href="http://curl.haxx.se/"><code>curl</code></a> and an <a href="{{uri base 'tokens'}}">API token</a> to download this data source to your computer:</p>

<pre>
curl -H 'Authorization: Token &lt;API token&gt;' 'https://&lt;domain&gt;{{data_source.data.uri}}' &gt; data.{{data_source.filetype}}{{#if data_source.gzipped}}.gz{{/if}}
</pre>

{{/inline}}
