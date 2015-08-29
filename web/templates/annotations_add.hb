<form action="{{base}}/data_sources/{{escape data_source.uri}}/annotations" method="post">
  <fieldset>

<label for="name">Name</label>
<input type="text" class="input-xlarge" name="name" id="name">

<label for="data_source">Data source</label>
<div class="form-picker input-xlarge" data-name="data_source">
  <div>
    <a href="{{base}}/picker/data_sources{{#if auth.rights.list_data_sources}}{{else}}?filter=own{{/if}}" class="picker-open">Choose a data source...</a>
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
  <a href="{{base}}/picker/samples" class="picker-open">Choose a sample...</a>
{{else}}
  <a href="{{base}}/picker/samples?filter=public" class="picker-open">Choose a sample (public samples)...</a>
  {{#if auth}}
    <a href="{{base}}/picker/samples?filter=own" class="picker-open">Choose a sample (my samples)...</a>
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
        <a href="{{base}}/picker/groups" class="picker-open">Choose a group...</a>
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
  <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Add annotation</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>
