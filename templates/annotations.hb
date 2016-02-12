{{#title}}Annotations{{/title}}

{{#if auth.rights.list_annotations}}
  <ul class="nav nav-pills">
{{else}}
  {{#if auth.rights.add_annotation}}
    <ul class="nav nav-pills">
  {{/if}}
{{/if}}

{{#if auth.rights.list_annotations}}
  <li class="{{#equals subpage 'list'}}{{#equals filter ''}}active{{/equals}}{{/equals}}">
    <a href="{{uri base 'annotations'}}"><i class="fa fa-th"></i> All annotations</a>
  </li>
{{/if}}

{{#if auth.rights.list_annotations}}
  <li class="{{#equals subpage 'list'}}{{#equals filter 'own'}}active{{/equals}}{{/equals}}">
    <a href="{{uri base 'annotations' filter='own'}}"><i class="fa fa-th-large"></i> My annotations</a>
  </li>
{{else}}
  {{#if auth.rights.add_annotation}}
    <li class="{{#equals subpage 'list'}}{{#equals filter 'own'}}active{{/equals}}{{/equals}}">
      <a href="{{uri base 'annotations' filter='own'}}"><i class="fa fa-th-large"></i> My annotations</a>
    </li>
  {{/if}}
{{/if}}

{{#if auth.rights.add_annotation}}
  <li class="pull-right{{#equals subpage 'add'}} active{{/equals}}">
    <a href="{{uri base 'annotations_add'}}"><i class="fa fa-plus"></i> Add annotation</a>
  </li>
{{/if}}

{{#if auth.rights.list_annotations}}
  </ul>
{{else}}
  {{#if auth.rights.add_annotation}}
    </ul>
  {{/if}}
{{/if}}

{{> (lookup . 'subpage') }}


{{#*inline 'add'}}

<form action="{{uri base 'annotations'}}" method="post">
  <fieldset>

<label for="name">Name</label>
<input type="text" class="input-xlarge" name="name" id="name">

<label for="data_source">Data source</label>
<div class="form-picker input-xlarge" data-name="data_source">
  <div>
    <a href="{{#if auth.rights.list_data_sources}}{{uri base 'picker' 'data_sources'}}{{else}}{{uri base 'picker' 'data_sources' filter='own'}}{{/if}}" class="picker-open">Choose a data source...</a>
  </div>
</div>

{{#if auth.rights.global_query}}
  <label>Query</label>
  <label class="radio">
    <input type="radio" name="query" value="global" checked="checked"> Global query
  </label>
{{/if}}

<label class="radio">
  <input type="radio" name="query" value="sample"{{#if auth.rights.global_query}}{{else}} checked="checked"{{/if}}> Sample query<br>
  <div class="form-picker input-xlarge" data-name="sample">
    <div>
{{#if auth.rights.list_samples}}
  <a href="{{uri base 'picker' 'samples'}}" class="picker-open">Choose a sample...</a>
{{else}}
  <a href="{{uri base 'picker' 'samples' filter='public'}}" class="picker-open">Choose a sample (public samples)...</a>
  {{#if auth}}
    <a href="{{uri base 'picker' 'samples' filter='own'}}" class="picker-open">Choose a sample (my samples)...</a>
  {{/if}}
{{/if}}
    </div>
  </div>
</label>

{{#if auth.rights.group_query}}
  <label class="radio">
    <input type="radio" name="query" value="group"> Group query<br>
    <div class="form-picker input-xlarge" data-name="group">
      <div>
        <a href="{{uri base 'picker' 'groups'}}" class="picker-open">Choose a group...</a>
      </div>
    </div>
  </label>
{{/if}}

{{#if auth.rights.query}}
  <label class="radio">
    <input type="radio" name="query" value="custom"> Custom query<br>
    <input type="text" class="input-xxlarge" name="custom">
  </label>
{{/if}}

<div class="form-actions">
  <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Add annotation</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>

{{/inline}}


{{#*inline 'list'}}

{{#if annotations}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Annotation</th><th class="cell-icon">Written</th></tr></thead>
    <tbody>
      {{#each annotations}}
      <tr data-href="{{uri ../base 'annotations' ./uri}}">
        <td>{{annotated_data_source.name}}</td>
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
  <p>No annotations are here.</p>
{{/if}}

{{/inline}}
