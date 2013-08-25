{{#title}}Annotations{{/title}}

{{#if auth.rights.list_annotations}}
  <ul class="nav nav-pills">
{{else}}
  {{#if auth.rights.add_annotation}}
    <ul class="nav nav-pills">
  {{/if}}
{{/if}}

{{#if auth.rights.list_annotations}}
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare=""}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/annotations"><i class="icon-th"></i> All annotations</a>
  </li>
{{/if}}

{{#if auth.rights.list_annotations}}
  <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}">
    <a href="{{base}}/annotations?filter=own"><i class="icon-th-large"></i> My annotations</a>
  </li>
{{else}}
  {{#if auth.rights.add_annotation}}
    <li class="{{#if_eq subpage compare="list"}}{{#if_eq filter compare="own"}}active{{/if_eq}}{{/if_eq}}">
      <a href="{{base}}/annotations?filter=own"><i class="icon-th-large"></i> My annotations</a>
    </li>
  {{/if}}
{{/if}}

{{#if auth.rights.add_annotation}}
  <li class="pull-right{{#if_eq subpage compare="add"}} active{{/if_eq}}">
    <a href="{{base}}/annotations_add"><i class="icon-plus"></i> Add annotation</a>
  </li>
{{/if}}

{{#if auth.rights.list_annotations}}
  </ul>
{{else}}
  {{#if auth.rights.add_annotation}}
    </ul>
  {{/if}}
{{/if}}

{{> subpage}}
