{{#title}}Samples{{/title}}

{{#if auth}}
  <ul class="nav nav-pills">
{{/if}}

{{#if auth.rights.list_samples}}
  <li class="{{#equals subpage 'list'}}{{#equals filter ''}}active{{/equals}}{{/equals}}">
    <a href="{{uri base 'samples'}}"><i class="fa fa-th"></i> All samples</a>
  </li>
{{/if}}

{{#if auth}}
  <li class="{{#equals subpage 'list'}}{{#equals filter 'public'}}active{{/equals}}{{/equals}}">
    <a href="{{uri base 'samples' filter='public'}}"><i class="fa fa-th-large"></i> Puplic samples</a>
  </li>
  <li class="{{#equals subpage 'list'}}{{#equals filter 'own'}}active{{/equals}}{{/equals}}">
    <a href="{{uri base 'samples' filter='own'}}"><i class="fa fa-th-large"></i> My samples</a>
  </li>
{{/if}}

{{#if auth.rights.add_sample}}
  <li class="pull-right{{#equals subpage 'add'}} active{{/equals}}">
    <a href="{{uri base 'samples_add'}}"><i class="fa fa-plus"></i> Add sample</a>
  </li>
{{/if}}

{{#if auth}}
  </ul>
{{/if}}

{{> (lookup . 'subpage') }}


{{#*inline 'list'}}

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


{{#*inline 'add'}}

<form action="{{uri base 'samples'}}" method="post">
  <fieldset>
    <label for="name">Sample name</label>
    <input type="text" class="input-xlarge" name="name" id="name">
    <label for="pool_size">Pool size</label>
    <div class="input-append">
      <input type="text" class="input-mini" text-align="right" name="pool_size" id="pool_size" value="1">
      <span class="add-on">individual(s)</span>
    </div>
    <label class="checkbox">
      <input type="checkbox" name="coverage_profile" checked> Coverage profile available
    </label>
    <label class="checkbox">
      <input type="checkbox" name="public"> Public
    </label>
    <label for="notes">Notes</label>
    <textarea class="input-xxlarge" rows="10" name="notes" id="notes"></textarea>
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Add sample</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}
