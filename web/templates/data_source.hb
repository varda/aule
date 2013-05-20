{{#title}}{{data_source.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
  <a href="{{base}}/data_sources/{{escape data_source.uri}}"><i class="icon-file"></i> Data source</a>
</li>

{{#if auth.roles.admin}}
  <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
    <a href="{{base}}/data_sources/{{escape data_source.uri}}/edit"><i class="icon-pencil"></i> Edit data source</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
    <a href="{{base}}/data_sources/{{escape data_source.uri}}/delete"><i class="icon-trash"></i> Delete data source</a>
  </li>
{{else}}
  {{#if_eq data_source.user.uri compare=auth.user.uri}}
    <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
      <a href="{{base}}/data_sources/{{escape data_source.uri}}/edit"><i class="icon-pencil"></i> Edit data source</a>
    </li>
    <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
      <a href="{{base}}/data_sources/{{escape data_source.uri}}/delete"><i class="icon-trash"></i> Delete data source</a>
    </li>
  {{/if_eq}}
{{/if}}

</ul>

{{> subpage}}
