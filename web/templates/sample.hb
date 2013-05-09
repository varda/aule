{{#title}}{{sample.name}}{{/title}}

<ul class="nav nav-pills">
  <li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
    <a href="{{base}}/samples/{{escape sample.uri}}"><i class="icon-file"></i> Sample</a>
  </li>
  <li class="{{#if_eq subpage compare="variations"}}active{{/if_eq}}">
    <a href="{{base}}/samples/{{escape sample.uri}}/variations"><i class="icon-th-large"></i> Variation</a>
  </li>
  <li class="{{#if_eq subpage compare="coverages"}}active{{/if_eq}}">
    <a href="{{base}}/samples/{{escape sample.uri}}/coverages"><i class="icon-th-large"></i> Coverage</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="edit"}} active{{/if_eq}}">
    <a href="{{base}}/samples/{{escape sample.uri}}/edit"><i class="icon-pencil"></i> Edit sample</a>
  </li>
  <li class="pull-right{{#if_eq subpage compare="delete"}} active{{/if_eq}}">
    <a href="{{base}}/samples/{{escape sample.uri}}/delete"><i class="icon-trash"></i> Delete sample</a>
  </li>
</ul>

{{> subpage}}
