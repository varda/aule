<form action="{{base}}/variants" method="get">
  <fieldset>
    <label for="sample">Sample</label>
    <select class="medium" name="sample" id="sample">
      <option value="">None (global)</option>
      {{#each samples}}
        <option value="{{uri}}">{{name}}</option>
      {{/each}}
    </select>
    <label for="chromosome">Chromosome name</label>
    <input type="text" name="chromosome" id="chromosome">
    <label for="begin">Region begin</label>
    <input type="text" name="begin" id="begin">
    <label for="start">Region end</label>
    <input type="text" name="end" id="end">
    <div class="form-actions">
      <button type="submit" class="btn btn-info"><i class="icon-info"></i> Lookup region</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
