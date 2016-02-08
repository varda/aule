{{#title}}{{token.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#equals subpage 'show'}}active{{/equals}}">
  <a href="{{uri base 'tokens' token.uri}}"><i class="fa fa-file"></i> API token</a>
</li>

<li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
  <a href="{{uri base 'tokens' token.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit API token</a>
</li>

<li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
  <a href="{{uri base 'tokens' token.uri 'delete'}}"><i class="fa fa-trash"></i> Revoke API token</a>
</li>

</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'delete'}}

<form action="{{uri base 'tokens' token.uri 'delete'}}" method="post">
  <input type="hidden" name="name" id="name" value="{{token.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="fa fa-trash"></i> Revoke API token</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'edit'}}

<form action="{{uri base 'tokens' token.uri 'edit'}}" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">API token name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{token.name}}">
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
      <td>{{token.name}}</td>
    </tr>
    <tr>
      <th scope="row">Added</td>
      <td>{{date token.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{token.uri}}</td>
    </tr>
  </tbody>
</table>

<p>
  <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#token-view"><i class="fa fa-lock"></i> Show token</button>
</p>

<div id="token-view" class="modal hide">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>{{token.name}}</h3>
  </div>
  <div class="modal-body">
    <pre class="text-center">{{token.key}}</pre>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>

{{/inline}}
