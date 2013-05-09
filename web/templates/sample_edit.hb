<form action="{{base}}/samples/{{escape sample.uri}}/edit" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">Sample name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{sample.name}}">
    <label for="pool_size">Pool size</label>
    <div class="input-append">
      <input type="text" class="input-mini" text-align="right" name="pool_size" id="pool_size" value="{{sample.pool_size}}">
      <span class="add-on">individual(s)</span>
    </div>
    <label class="checkbox">
      <input type="checkbox" name="coverage_profile"{{#if sample.coverage_profile}} checked{{/if}}> Coverage profile available
    </label>
    <label class="checkbox">
      <input type="checkbox" name="public"{{#if sample.public}} checked{{/if}}> Public
    </label>
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="icon-pencil"></i> Edit sample</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
