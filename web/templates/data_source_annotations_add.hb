<form action="{{base}}/data_sources/{{escape data_source.uri}}/annotations" method="post">
  <fieldset>
    <label for="name">Name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{data_source.name}} (annotated)">
    <label>Sample frequencies</label>
    <div class="grouping grouping-xlarge">
    {{#each samples}}
      <label class="checkbox">
        <input type="checkbox" name="sample_frequency" value="{{uri}}"> {{name}}
      </label>
    {{/each}}
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
