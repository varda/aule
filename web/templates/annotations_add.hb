<form action="{{base}}/data_sources/{{escape data_source.uri}}/annotations" method="post">
  <fieldset>
    <label for="name">Name</label>
    <input type="text" class="input-xlarge" name="name" id="name">
    <label>Data source</label>
    <div class="form-picker input-xlarge" data-name="data_source">
      <div>
        <a href="{{base}}/picker/data_sources{{#if auth.rights.list_data_sources}}{{else}}?filter=own{{/if}}" class="picker-open">Choose a data source...</a>
      </div>
    </div>
    <label>Sample frequencies</label>
    <div class="form-picker input-xlarge" data-name="sample_frequency" data-multi="true">
      <div>
        <a href="{{base}}/picker/samples?filter=public" class="picker-open">Add a sample...</a>
      </div>
    </div>
    <label class="checkbox">
      <input type="checkbox" name="global_frequency" checked> Global frequencies
    </label>
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Add annotation</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
