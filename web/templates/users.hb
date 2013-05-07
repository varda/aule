{{#title}}Users{{/title}}

<ul class="nav nav-pills">
  {{#if auth.rights.list_users}}
    <li{{#if_eq subpage compare="list"}} class="active"{{/if_eq}}><a href="{{base}}/users"><i class="icon-th"></i> All users</a></li>
  {{/if}}
  {{#if auth.rights.add_user}}
    <li class="{{#if_eq subpage compare="add"}}active {{/if_eq}}pull-right"><a href="{{base}}/users_add"><i class="icon-plus"></i> Add user</a></li>
  {{/if}}
</ul>

{{> subpage}}
