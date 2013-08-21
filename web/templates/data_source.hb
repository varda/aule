{{#title}}{{data_source.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
  <a href="{{base}}/data_sources/{{escape data_source.uri}}"><i class="icon-file"></i> Data source</a>
</li>

{{#if auth.roles.admin}}
  <li class="{{#if_eq subpage compare="annotations"}}active{{/if_eq}}">
    <a href="{{base}}/data_sources/{{escape data_source.uri}}/annotations"><i class="icon-th-large"></i> Annotations</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
    <a href="{{base}}/data_sources/{{escape data_source.uri}}/edit"><i class="icon-pencil"></i> Edit data source</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
    <a href="{{base}}/data_sources/{{escape data_source.uri}}/delete"><i class="icon-trash"></i> Delete data source</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="annotations_add"}} active{{/if_eq}}">
    <a href="{{base}}/data_sources/{{escape data_source.uri}}/annotations_add"><i class="icon-plus"></i> Add annotation</a>
  </li>
{{else}}
  {{#if_eq data_source.user.uri compare=auth.user.uri}}
    <li class="{{#if_eq subpage compare="annotations"}}active{{/if_eq}}">
      <a href="{{base}}/data_sources/{{escape data_source.uri}}/annotations"><i class="icon-th-large"></i> Annotations</a>
    </li>
    <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
      <a href="{{base}}/data_sources/{{escape data_source.uri}}/edit"><i class="icon-pencil"></i> Edit data source</a>
    </li>
    <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
      <a href="{{base}}/data_sources/{{escape data_source.uri}}/delete"><i class="icon-trash"></i> Delete data source</a>
    </li>
    {{#if auth.roles.annotator}}
      <li class="pull-right{{#if_eq subpage compare="annotations_add"}} active{{/if_eq}}">
        <a href="{{base}}/data_sources/{{escape data_source.uri}}/annotations_add"><i class="icon-plus"></i> Add annotation</a>
      </li>
    {{else}}
      {{#if auth.roles.trader}}
        <li class="pull-right{{#if_eq subpage compare="annotations_add"}} active{{/if_eq}}">
          <a href="{{base}}/data_sources/{{escape data_source.uri}}/annotations_add"><i class="icon-plus"></i> Add annotation</a>
        </li>
      {{/if}}
    {{/if}}
  {{/if_eq}}
{{/if}}

</ul>

{{> subpage}}
