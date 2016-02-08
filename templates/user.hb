{{#title}}{{user.name}}{{/title}}

<ul class="nav nav-pills">
  <li class="{{#equals subpage 'show'}}active{{/equals}}">
    <a href="{{uri base 'users' user.uri}}"><i class="fa fa-file"></i> User</a>
  </li>
  <li class="pull-right{{#equals subpage 'edit'}} active{{/equals}}">
    <a href="{{uri base 'users' user.uri 'edit'}}"><i class="fa fa-pencil"></i> Edit user</a>
  </li>
  <li class="pull-right{{#equals subpage 'delete'}} active{{/equals}}">
    <a href="{{uri base 'users' user.uri 'delete'}}"><i class="fa fa-trash"></i> Delete user</a>
  </li>
</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'delete'}}

<form action="{{uri base 'users' user.uri 'delete'}}" method="post">
  <input type="hidden" name="name" id="name" value="{{user.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="fa fa-trash"></i> Delete user</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'edit'}}

<form action="{{uri base 'users' user.uri 'edit'}}" method="post" class="form-edit">
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
      <button type="submit" class="btn btn-warning"><i class="fa fa-pencil"></i> Save changes</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'show'}}

<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Name</th>
      <td>{{user.name}}</td>
    </tr>
    <tr>
      <th scope="row">Login</th>
      <td>{{user.login}}</td>
    </tr>
    {{#if user.email}}
    <tr>
      <th scope="row">Email</th>
      <td><a href="mailto:{{user.email}}">{{user.email}}</a></td>
    </tr>
    {{/if}}
    <tr>
      <th scope="row">Roles</th>
      <td>
      {{#if user.roles}}
        {{#each user.roles}}
          {{this}}{{#unless @last}}, {{/unless}}
        {{/each}}
      {{else}}
        None
      {{/if}}
      </td>
    </tr>
    <tr>
      <th scope="row">Added</th>
      <td>{{date user.added}}</td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{user.uri}}</td>
    </tr>
  </tbody>
</table>

{{/inline}}
