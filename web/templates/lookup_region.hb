<form action="{{base}}/variants" method="get">
  <fieldset>
    <label for="sample">Sample</label>
    <select class="input-xlarge" name="sample" id="sample">
      <option value="">None (global)</option>
      {{#each samples}}
        <option value="{{uri}}">{{name}}</option>
      {{/each}}
    </select>
    <label for="chromosome">Chromosome</label>
    <select class="input-xlarge" name="chromosome" id="chromosome">
      {{#each chromosomes}}
        <option value="{{this}}">{{this}}</option>
      {{/each}}
    </select>
    <label for="begin">Region begin</label>
    <input type="text" class="input-medium" name="begin" id="begin">
    <label for="end">Region end</label>
    <input type="text" class="input-medium" name="end" id="end">
    <div class="form-actions">
      <button type="submit" class="btn btn-info"><i class="icon-info"></i> Lookup region</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
