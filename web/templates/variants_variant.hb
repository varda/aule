<form action="/aule/variants_variant" method="post">
  <fieldset>
    <label for="chromosome">Chromosome name</label>
    <input type="text" name="chromosome" id="chromosome">
    <label for="position">Position</label>
    <input type="text" name="position" id="position">
    <label for="reference">Reference sequence</label>
    <input type="text" name="reference" id="reference">
    <label for="observed">Observed sequence</label>
    <input type="text" name="observed" id="observed">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Lookup variant</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
