<form action="{{base}}/groups/{{escape group.uri}}/edit" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">Group name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{group.name}}">
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="icon-pencil"></i> Save changes</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
