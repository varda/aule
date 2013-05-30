<form action="{{base}}/users/{{escape user.uri}}/delete" method="post">
  <input type="hidden" name="name" id="name" value="{{user.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="icon-trash"></i> Delete user</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
