{{#if samples}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th><th class="cell-icon">Active</th><th class="cell-icon">Public</th><th class="cell-icon">Notes</th><th>Added</th></tr></thead>
    <tbody>
      {{#each samples}}
      <tr data-href="{{../base}}/samples/{{escape uri}}">
        <td>{{name}}</td>
        <td class="cell-icon">{{#if active}}<i class="icon-ok"></i>{{/if}}</td>
        <td class="cell-icon">{{#if public}}<i class="icon-ok"></i>{{/if}}</td>
        <td class="cell-icon">{{#if notes}}<i class="icon-ok"></i>{{/if}}</td>
        <td>{{dateFormat added}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No samples are here.</p>
{{/if}}
