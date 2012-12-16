<form action="/varda-web/data_sources" method="post">
  <fieldset>
    <label for="name">Name</label>
    <input type="text" name="name" id="name">
    <label for="filetype">Filetype</label>
    <select class="medium" name="filetype" id="filetype">
      <option>vcf</option>
      <option>bed</option>
    </select>
    <label for="local_path">Path on server</label>
    <input type="text" name="local_path">
    <div class="form-actions">
      <button type="submit" class="btn btn-primary">Add data source</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
