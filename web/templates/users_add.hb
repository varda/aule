<form action="{{base}}/users" method="post">
  <fieldset>
    <label for="name">User name</label>
    <input type="text" class="input-xlarge" name="name" id="name">
    <label for="login">Login</label>
    <input type="text" class="input-xlarge" name="login" id="login">
    <label for="password">Password (twice)</label>
    <input type="password" class="input-xlarge" name="password" id="password">
    <input type="password" class="input-xlarge" name="password_check">
    <label for="email">Email</label>
    <input type="text" class="input-xlarge" name="email" id="email">
    <label for="roles">Roles</label>
    <input type="text" class="input-xlarge" name="roles" id="roles">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Add user</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
