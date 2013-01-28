<form action="/aule/users" method="post">
  <fieldset>
    <label for="name">Name</label>
    <input type="text" name="name" id="name">
    <label for="login">Login</label>
    <input type="text" name="login" id="login">
    <label for="password">Password (twice)</label>
    <input type="password" name="password" id="password">
    <input type="password" name="password_check">
    <label for="roles">Roles</label>
    <input type="text" name="roles" id="roles">
    <div class="form-actions">
      <button type="submit" class="btn btn-succes"><i class="icon-plus"></i> Add user</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
