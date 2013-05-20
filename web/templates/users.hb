{{#title}}Users{{/title}}

{{#if auth.rights.list_users}}
  {{#if auth.rights.add_user}}
    <ul class="nav nav-pills">
      <li class="{{#if_eq subpage compare="list"}}active{{/if_eq}}">
        <a href="{{base}}/users"><i class="icon-th"></i> All users</a>
      </li>
      <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}">
        <a href="{{base}}/users_add"><i class="icon-plus"></i> Add user</a>
      </li>
    </ul>
  {{/if}}
{{/if}}

{{> subpage}}
