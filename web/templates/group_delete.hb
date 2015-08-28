<form action="{{base}}/groups/{{escape group.uri}}/delete" method="post">
  <input type="hidden" name="name" id="name" value="{{group.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="icon-trash"></i> Delete group</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
