{{#title}}{{annotation.annotated_data_source.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#if_eq subpage compare="show"}}active{{/if_eq}}">
  <a href="{{base}}/annotations/{{escape annotation.uri}}"><i class="icon-file"></i> Annotation</a>
</li>

</ul>

{{> subpage}}
