<form action="/varda-web/samples/{{escape sample.uri}}/edit" method="post">
  <fieldset>
    <label for="name">Name</label>
    <input type="text" name="name" id="name" value="{{sample.name}}">
    <label for="coverage_threshold">Coverage threshold</label>
    <input type="text" class="mini" name="coverage_threshold" id="coverage_threshold" value="{{sample.coverage_threshold}}">
    <label for="pool_size">Pool size</label>
    <input type="text" class="mini" name="pool_size" id="pool_size" value="{{sample.pool_size}}">
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="icon-pencil"></i> Edit sample</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
