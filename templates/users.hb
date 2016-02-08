{{#title}}Users{{/title}}

{{#if auth.rights.list_users}}
  {{#if auth.rights.add_user}}
    <ul class="nav nav-pills">
      <li class="{{#equals subpage 'list'}}active{{/equals}}">
        <a href="{{uri base 'users'}}"><i class="fa fa-th"></i> All users</a>
      </li>
      <li class="pull-right{{#equals subpage 'add'}} active{{/equals}}">
        <a href="{{uri base 'users_add'}}"><i class="fa fa-plus"></i> Add user</a>
      </li>
    </ul>
  {{/if}}
{{/if}}

{{> (lookup . 'subpage') }}


{{#*inline 'add'}}

<form action="{{uri base 'users'}}" method="post">
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
      <label class="checkbox">
        <input type="checkbox" name="roles" value="querier"> Querier
      </label>
      <label class="checkbox">
        <input type="checkbox" name="roles" value="group-querier"> Group querier
      </label>
    </div>
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Add user</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'list'}}

{{#if users}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th><th>Login</th><th>Roles</th><th>Added</th></tr></thead>
    <tbody>
      {{#each users}}
      <tr data-href="{{uri ../base 'users' ./uri}}">
        <td>{{name}}</td>
        <td>{{login}}</td>
        <td>{{roles}}</td>
        <td>{{date added}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No users are here.</p>
{{/if}}

{{/inline}}
