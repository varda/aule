<ul class="nav nav-pills">
  <li{{#if_eq current compare="users"}} class="active"{{/if_eq}}><a href="/varda-web/users"><i class="icon-th"></i> All users</a></li>
  <li class="{{#if_eq current compare="users_add"}}active {{/if_eq}}pull-right"><a href="/varda-web/users_add"><i class="icon-plus"></i> Add user</a></li>
</ul>

{{> page}}
