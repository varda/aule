<form action="{{base}}/samples/{{escape sample.uri}}/delete" method="post">
  <input type="hidden" name="name" id="name" value="{{sample.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="icon-trash"></i> Delete sample</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
