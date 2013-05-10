{{#title}}{{user.name}}{{/title}}

<ul class="nav nav-pills">
  <li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
    <a href="{{base}}/users/{{escape user.uri}}"><i class="icon-file"></i> User</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
    <a href="{{base}}/users/{{escape user.uri}}/edit"><i class="icon-pencil"></i> Edit user</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
    <a href="{{base}}/users/{{escape user.uri}}/delete"><i class="icon-trash"></i> Delete user</a>
  </li>
</ul>

{{> subpage}}
