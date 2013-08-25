{{#if pagination}}
  <div class="pagination pagination-centered{{#if pagination.many_pages}} pagination-mini{{/if}}">
    <ul>
      {{#if pagination.previous}}
        <li><a href="{{updatePath path page=pagination.previous.page}}">←</a></li>
      {{else}}
        <li class="disabled"><a>←</a></li>
      {{/if}}
      {{#each pagination.pages}}
        <li{{#if active}} class="active"{{/if}}><a href="{{updatePath ../path page=page}}">{{label}}</a></li>
      {{/each}}
      {{#if pagination.next}}
        <li><a href="{{updatePath path page=pagination.next.page}}">→</a></li>
      {{else}}
        <li class="disabled"><a>→</a></li>
      {{/if}}
    </ul>
  </div>
{{/if}}
