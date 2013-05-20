{{#title}}{{token.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
  <a href="{{base}}/tokens/{{escape token.uri}}"><i class="icon-file"></i> API token</a>
</li>

<li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
  <a href="{{base}}/tokens/{{escape token.uri}}/edit"><i class="icon-pencil"></i> Edit API token</a>
</li>

<li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
  <a href="{{base}}/tokens/{{escape token.uri}}/delete"><i class="icon-trash"></i> Revoke API token</a>
</li>

</ul>

{{> subpage}}
