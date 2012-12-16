<ul class="nav nav-pills">
  <li class="active"><a href="/varda-web/samples">Info</a></li>
  <li><a href="/varda-web/samples">Edit sample</a></li>
  <li><a href="/varda-web/add_sample">Import observations</a></li>
</ul>

<dl>
  <dt>Name</dt>
  <dd>{{sample.name}}</dd>
  <dt>Added</dd>
  <dd>{{sample.added}}</dd>
</dl>

<hr>

<h2>Import observations</h2>

<!-- Todo: We cannot upload a file with Ajax -->
<form id="import_observations" action="/api/v1/data_sources" method="post" enctype="multipart/form-data">
  <fieldset>
    <label>Description</label>
    <input type="text" id="data_source_name">
    <label>VCF file</label>
    <input type="file" class="input-file" id="data_source_data">
    <div class="form-actions">
      <button type="submit" class="btn btn-primary">Import observations</button>
      <button type="reset" class="btn">Cancel</button>
    </div>
  </fieldset>
</form>
