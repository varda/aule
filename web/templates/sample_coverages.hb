{{#if coverages}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Data source</th><th class="cell-icon">Imported</th></tr></thead>
    <tbody>
      {{#each coverages}}
      <tr>
        <td>{{data_source.name}}</td>
        <td class="cell-icon">
{{#if task.done}}
  <i class="icon-ok"></i>
{{else}}
  {{#if_eq task.state compare="failure"}}
    <i class="icon-warning-sign" title="{{task.error.message}}"></i>
  {{/if_eq}}
  {{#if_eq task.state compare="started"}}
    <i class="icon-spinner></i>
  {{/if_eq}}
  {{#if_eq task.state compare="progress"}}
    <i class="icon-spinner" title="{{task.progress}}"></i>
  {{/if_eq}}
{{/if}}
        </td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No regions are here.</p>
{{/if}}
