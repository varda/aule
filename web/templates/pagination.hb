{{#if pages}}
  <div class="pagination pagination-centered{{#if pages.many}} pagination-mini{{/if}}">
    <ul>
      {{#if pages.prev}}
        <li><a href="?page={{pages.prev.page}}">←</a></li>
      {{else}}
        <li class="disabled"><a>←</a></li>
      {{/if}}
      {{#each pages}}
        <li{{#if active}} class="active"{{/if}}><a href="?page={{page}}">{{label}}</a></li>
      {{/each}}
      {{#if pages.next}}
        <li><a href="?page={{pages.next.page}}">→</a></li>
      {{else}}
        <li class="disabled"><a>→</a></li>
      {{/if}}
    </ul>
  </div>
{{/if}}
