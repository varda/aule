{{#title}}{{sample.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#equals subpage 'show'}}active{{/equals}}">
  <a href="{{uri base 'samples' sample.uri}}"><i class="fa fa-file"></i> Sample</a>
</li>

{{#if auth.roles.admin}}
  <li class="{{#equals subpage 'variations'}}active{{/equals}}">
    <a href="{{uri base 'samples' sample.uri 'variations'}}"><i class="fa fa-th-large"></i> Variation</a>
  </li>
  <li class="{{#equals subpage 'coverages'}}active{{/equals}}">
    <a href="{{uri base 'samples' sample.uri 'coverages'}}"><i class="fa fa-th-large"></i> Coverage</a>
  </li>
  <li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
    <a href="{{uri base 'samples' sample.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit sample</a>
  </li>
  <li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
    <a href="{{uri base 'samples' sample.uri 'delete'}}"><i class="fa fa-trash"></i> Delete sample</a>
  </li>
{{else}}
  {{#equals sample.user.uri auth.user.uri}}
    <li class="{{#equals subpage 'variations'}}active{{/equals}}">
      <a href="{{uri base 'samples' sample.uri 'variations'}}"><i class="fa fa-th-large"></i> Variation</a>
    </li>
    <li class="{{#equals subpage 'coverages'}}active{{/equals}}">
      <a href="{{uri base 'samples' sample.uri 'coverages'}}"><i class="fa fa-th-large"></i> Coverage</a>
    </li>
    <li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
      <a href="{{uri base 'samples' sample.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit sample</a>
    </li>
    <li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
      <a href="{{uri base 'samples' sample.uri 'delete'}}"><i class="fa fa-trash"></i> Delete sample</a>
    </li>
  {{/equals}}
{{/if}}

</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'coverages'}}

{{#if coverages}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Data source</th><th class="cell-icon">Imported</th></tr></thead>
    <tbody>
      {{#each coverages}}
      <tr>
        <td>{{data_source.name}}</td>
        <td class="cell-icon">
{{#equals task.state 'waiting'}}
  <i class="fa fa-spinner fa-spin"></i>
{{/equals}}
{{#equals task.state 'running'}}
  <div class="progress" title="{{task.progress}}%">
    <div class="bar" style="width: {{task.progress}}%;"></div>
  </div>
{{/equals}}
{{#equals task.state 'success'}}
  <i class="fa fa-check"></i>
{{/equals}}
{{#equals task.state 'failure'}}
  <i class="fa fa-warning" title="{{task.error.message}}"></i>
{{/equals}}
        </td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No regions are here.</p>
{{/if}}

{{/inline}}


{{#*inline 'delete'}}

<form action="{{uri base 'samples' sample.uri 'delete'}}" method="post">
  <input type="hidden" name="name" id="name" value="{{sample.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="fa fa-trash"></i> Delete sample</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'edit'}}

<form action="{{uri base 'samples' sample.uri 'edit'}}" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">Sample name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{sample.name}}">
    <label for="groups">Groups</label>
    <div class="form-picker input-xlarge" data-name="groups" data-multi="true">
      {{#each sample.groups}}
        <div>
          <input name="groups" type="hidden" value="{{./uri}}">
          <i class="fa fa-remove"></i> {{name}}
        </div>
      {{/each}}
      <div>
        <a href="{{uri base 'picker' 'groups'}}" class="picker-open">Add a group...</a>
      </div>
    </div>
    <label for="pool_size">Pool size</label>
    <div class="input-append">
      <input type="text" class="input-mini" text-align="right" name="pool_size" id="pool_size" value="{{sample.pool_size}}">
      <span class="add-on">individual(s)</span>
    </div>
    <label class="checkbox">
      <input type="checkbox" name="coverage_profile"{{#if sample.coverage_profile}} checked{{/if}}> Coverage profile available
    </label>
    <label class="checkbox">
      <input type="checkbox" name="public"{{#if sample.public}} checked{{/if}}> Public
    </label>
    <label for="notes">Notes (you can use <a href="http://daringfireball.net/projects/markdown/syntax">Markdown</a>)</label>
    <textarea class="input-xxlarge" rows="10" name="notes" id="notes">{{sample.notes}}</textarea>
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
      <td>{{sample.name}}</td>
    </tr>
    <tr>
      <th scope="row">User</th>
      <td><a href="{{uri base 'users' sample.user.uri}}">{{sample.user.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Groups</th>
      <td>
      {{#if sample.groups}}
        {{#each sample.groups}}
          <a href="{{uri ../base 'groups' ./uri}}">{{name}}</a>{{#unless @last}}, {{/unless}}
        {{/each}}
      {{else}}
        None
      {{/if}}
      </td>
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
      <td>{{date sample.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{sample.uri}}</td>
    </tr>
  </tbody>
</table>

{{#if sample.notes}}
<h2>Notes</h2>
{{{markdown sample.notes}}}
{{/if}}

{{/inline}}


{{#*inline 'variations'}}

{{#if variations}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Data source</th><th class="cell-icon">Imported</th></tr></thead>
    <tbody>
      {{#each variations}}
      <tr>
        <td>{{data_source.name}}</td>
        <td class="cell-icon">
{{#equals task.state 'waiting'}}
  <i class="fa fa-spinner fa-spin"></i>
{{/equals}}
{{#equals task.state 'running'}}
  <div class="progress" title="{{task.progress}}%">
    <div class="bar" style="width: {{task.progress}}%;"></div>
  </div>
{{/equals}}
{{#equals task.state 'success'}}
  <i class="fa fa-check"></i>
{{/equals}}
{{#equals task.state 'failure'}}
  <i class="fa fa-warning" title="{{task.error.message}}"></i>
{{/equals}}
        </td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No observations are here.</p>
{{/if}}

{{/inline}}
