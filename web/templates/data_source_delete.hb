<form action="{{base}}/data_sources/{{escape data_source.uri}}/delete" method="post">
  <input type="hidden" name="name" id="name" value="{{data_source.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="icon-trash"></i> Delete data source</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
