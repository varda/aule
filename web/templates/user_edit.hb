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
    <label>Roles</label>
    <div class="grouping grouping-xlarge">
      <label class="checkbox">
        <input type="checkbox" name="roles" value="admin"{{#if user.roles.admin}} checked{{/if}}> Admin
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="importer"{{#if user.roles.importer}} checked{{/if}}> Importer
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="annotator"{{#if user.roles.annotator}} checked{{/if}}> Annotator
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="trader"{{#if user.roles.trader}} checked{{/if}}> Trader
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="querier"{{#if user.roles.querier}} checked{{/if}}> Querier
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="group-querier"{{#if user.roles.group_querier}} checked{{/if}}> Group querier
      </label>
    </div>
    <div class="form-actions">
      <button type="submit" class="btn btn-warning"><i class="icon-pencil"></i> Save changes</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
