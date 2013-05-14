{{#if variations}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Data source</th><th>Imported</th></tr></thead>
    <tbody>
      {{#each variations}}
      <tr>
        <td>{{data_source.name}}</td>
        <td>
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
  <p>No observations are here.</p>
{{/if}}
