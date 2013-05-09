<form action="{{base}}/variants_region" method="post">
  <fieldset>
    <label for="sample">Sample</label>
    <select class="medium" name="sample" id="sample">
      <option value="">None (global)</option>
      {{#each samples}}
        <option value="{{uri}}">{{name}}</option>
      {{/each}}
    </select>
    <label for="start">Region start</label>
    <input type="text" name="start" id="start">
    <label for="start">Region end</label>
    <input type="text" name="end" id="end">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Lookup region</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
