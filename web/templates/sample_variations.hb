{{#if variations}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Data source</th><th class="cell-icon">Imported</th></tr></thead>
    <tbody>
      {{#each variations}}
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
    <i class="icon-spinner icon-spin"></i>
  {{/if_eq}}
  {{#if_eq task.state compare="progress"}}
    <div class="progress">
      <div class="bar" style="width: {{task.progress}}%;" title="{{task.progress}}%"></div>
    </div>
  {{/if_eq}}
{{/if}}
        </td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No observations are here.</p>
{{/if}}
