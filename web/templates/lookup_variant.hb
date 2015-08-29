<form action="{{base}}/lookup_variant" method="post">
  <fieldset>
    <label for="sample">Sample frequency (leave empty for global frequency)</label>
    <div class="form-picker input-xlarge" data-name="sample">
      <div>
        <a href="{{base}}/picker/samples?filter=public" class="picker-open">Choose a sample...</a>
      </div>
    </div>
    <label for="chromosome">Chromosome</label>
    <select class="input-xlarge" name="chromosome" id="chromosome">
      {{#each chromosomes}}
        <option value="{{this}}">{{this}}</option>
      {{/each}}
    </select>
    <label for="position">Position</label>
    <input type="text" class="input-medium" name="position" id="position">
    <label for="reference">Reference sequence</label>
    <input type="text" class="input-xlarge" name="reference" id="reference">
    <label for="observed">Observed sequence</label>
    <input type="text" class="input-xlarge" name="observed" id="observed">
    <div class="form-actions">
      <button type="submit" class="btn btn-info"><i class="icon-info"></i> Lookup variant</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
