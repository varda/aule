<form action="/varda-web/samples" method="post">
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
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Add sample</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
