<form action="{{base}}/data_sources" method="post">
  <fieldset>
    <label for="name">Data source name</label>
    <input type="text" class="input-xlarge" name="name" id="name">
    <label for="filetype">Filetype</label>
    <select class="medium" name="filetype" id="filetype">
      <option>vcf</option>
      <option>bed</option>
    </select>
    <label for="local_path">Path on server</label>
    <input type="text" class="input-xlarge" name="local_path">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Add data source</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
