{{#title}}{{group.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#equals subpage 'show'}}active{{/equals}}">
  <a href="{{uri base 'groups' group.uri}}"><i class="fa fa-file"></i> Group</a>
</li>

{{#if auth.rights.list_samples}}
  <li class="{{#equals subpage 'samples'}}active{{/equals}}">
    <a href="{{uri base 'groups' group.uri 'samples'}}"><i class="fa fa-th-large"></i> Samples</a>
  </li>
{{/if}}

{{#if auth.roles.admin}}
  <li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
    <a href="{{uri base 'groups' group.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit group</a>
  </li>
  <li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
    <a href="{{uri base 'groups' group.uri 'delete'}}"><i class="fa fa-trash"></i> Delete group</a>
  </li>
{{/if}}

</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'delete'}}

<form action="{{uri base 'groups' group.uri 'delete'}}" method="post">
  <input type="hidden" name="name" id="name" value="{{group.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="fa fa-trash"></i> Delete group</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'edit'}}

<form action="{{uri base 'groups' group.uri 'edit'}}" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">Group name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{group.name}}">
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="fa fa-pencil"></i> Save changes</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'samples'}}

{{#if samples}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th><th class="cell-icon">Active</th><th class="cell-icon">Public</th><th class="cell-icon">Notes</th><th>Added</th></tr></thead>
    <tbody>
      {{#each samples}}
      <tr data-href="{{uri ../base 'samples' ./uri}}">
        <td>{{name}}</td>
        <td class="cell-icon">{{#if active}}<i class="fa fa-check"></i>{{/if}}</td>
        <td class="cell-icon">{{#if public}}<i class="fa fa-check"></i>{{/if}}</td>
        <td class="cell-icon">{{#if notes}}<i class="fa fa-check"></i>{{/if}}</td>
        <td>{{date added}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No samples are here.</p>
{{/if}}

{{/inline}}


{{#*inline 'show'}}

<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Name</th>
      <td>{{group.name}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{group.uri}}</td>
    </tr>
  </tbody>
</table>

{{/inline}}
