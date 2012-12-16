<ul class="nav nav-pills">
  <li{{#if_eq tab compare="users"}} class="active"{{/if_eq}}><a href="/varda-web/users"><i class="icon-th"></i> All users</a></li>
  <li class="{{#if_eq tab compare="add_user"}}active {{/if_eq}}pull-right"><a href="/varda-web/add_user"><i class="icon-plus"></i> Add user</a></li>
</ul>

{{> page}}
