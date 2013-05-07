{{#title}}Sample: {{sample.name}}{{/title}}

<ul class="nav nav-pills">
  <li{{#if_eq subpage compare="show"}} class="active"{{/if_eq}}><a href="{{base}}/samples/{{escape sample.uri}}"><i class="icon-file"></i> Details</a></li>
  <li{{#if_eq subpage compare="variations"}} class="active"{{/if_eq}}><a href="{{base}}/samples/{{escape sample.uri}}/variations"><i class="icon-th-large"></i> Variation</a></li>
  <li{{#if_eq subpage compare="coverages"}} class="active"{{/if_eq}}><a href="{{base}}/samples/{{escape sample.uri}}/coverages"><i class="icon-th-large"></i> Coverage</a></li>
  <li class="{{#if_eq subpage compare="edit"}}active {{/if_eq}}pull-right"><a href="{{base}}/samples/{{escape sample.uri}}/edit"><i class="icon-pencil"></i> Edit sample</a></li>
  <li class="{{#if_eq subpage compare="delete"}}active {{/if_eq}}pull-right"><a href="{{base}}/samples/{{escape sample.uri}}/delete"><i class="icon-trash"></i> Delete sample</a></li>
</ul>

{{> subpage}}
