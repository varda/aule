{{#title}}API tokens{{/title}}

<ul class="nav nav-pills">

<li class="{{#if_eq subpage compare="list"}}active{{/if_eq}}">
  <a href="{{base}}/tokens"><i class="icon-th"></i> My API tokens</a>
</li>

<li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}">
  <a href="{{base}}/tokens_add"><i class="icon-plus"></i> Generate API token</a>
</li>

</ul>

{{> subpage}}
