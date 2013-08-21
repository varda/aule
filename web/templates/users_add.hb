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
    <label>Roles</label>
    <div class="grouping grouping-xlarge">
      <label class="checkbox">
        <input type="checkbox" name="roles" value="admin"> Admin
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="importer"> Importer
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="annotator"> Annotator
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="trader"> Trader
      </label>
    </div>
    <label for="email">Email</label>
    <input type="text" class="input-xlarge" name="email" id="email">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-plus"></i> Add user</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
