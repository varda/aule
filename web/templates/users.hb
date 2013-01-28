<ul class="nav nav-pills">
  {{#if auth.rights.list_users}}
    <li{{#if_eq current compare="users"}} class="active"{{/if_eq}}><a href="/aule/users"><i class="icon-th"></i> All users</a></li>
  {{/if}}
  {{#if auth.rights.add_user}}
    <li class="{{#if_eq current compare="users_add"}}active {{/if_eq}}pull-right"><a href="/aule/users_add"><i class="icon-plus"></i> Add user</a></li>
  {{/if}}
</ul>

{{> page}}
