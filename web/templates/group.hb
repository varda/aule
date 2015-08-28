{{#title}}{{group.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
  <a href="{{base}}/groups/{{escape group.uri}}"><i class="icon-file"></i> Group</a>
</li>

{{#if auth.roles.admin}}
  <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
    <a href="{{base}}/groups/{{escape group.uri}}/edit"><i class="icon-pencil"></i> Edit group</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
    <a href="{{base}}/groups/{{escape group.uri}}/delete"><i class="icon-trash"></i> Delete group</a>
  </li>
{{/if}}

</ul>

{{> subpage}}
