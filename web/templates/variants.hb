{{#title}}Variants{{/title}}

<ul class="nav nav-pills">
  <li{{#if_eq subpage compare="variant"}} class="active"{{/if_eq}}><a href="{{base}}/variants_variant"><i class="icon-comment"></i> Lookup variant</a></li>
  <li{{#if_eq subpage compare="region"}} class="active"{{/if_eq}}><a href="{{base}}/variants_region"><i class="icon-comments"></i> Lookup region</a></li>
</ul>

{{> subpage}}
