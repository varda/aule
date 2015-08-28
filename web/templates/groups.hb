{{#title}}Groups{{/title}}

{{#if auth.rights.add_group}}
  <ul class="nav nav-pills">
    <li class="{{#if_eq subpage compare="list"}}active{{/if_eq}}">
      <a href="{{base}}/groups"><i class="icon-th"></i> All groups</a>
    </li>
    <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}">
      <a href="{{base}}/groups_add"><i class="icon-plus"></i> Add group</a>
    </li>
  </ul>
{{/if}}

{{> subpage}}
