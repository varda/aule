{{#title}}Frequency lookup{{/title}}

<ul class="nav nav-pills">
  <li{{#if_eq subpage compare="variant"}} class="active"{{/if_eq}}><a href="{{base}}/lookup_variant"><i class="icon-comment"></i> By variant</a></li>
  <li{{#if_eq subpage compare="region"}} class="active"{{/if_eq}}><a href="{{base}}/lookup_region"><i class="icon-comments"></i> By region</a></li>
</ul>

{{> subpage}}
