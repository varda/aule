<form action="{{base}}/users/{{escape user.uri}}/edit" method="post" class="form-edit">
  <input type="hidden" name="dirty" id="dirty" value="">
  <fieldset>
    <label for="name">User name</label>
    <input type="text" class="input-xlarge" name="name" id="name" value="{{user.name}}">
    <label for="password">Password (twice)</label>
    <input type="password" class="input-xlarge" name="password" id="password">
    <input type="password" class="input-xlarge" name="password_check">
    <label for="email">Email</label>
    <input type="text" class="input-xlarge" name="email" id="email" value="{{user.email}}">
    <label for="roles">Roles</label>
    <input type="text" class="input-xlarge" name="roles" id="roles" value="{{user.roles}}">
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="icon-pencil"></i> Save changes</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
