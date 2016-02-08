{{#pickerTitle}}Choose a sample{{/pickerTitle}}

{{#if samples}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th><th class="cell-icon">Active</th><th class="cell-icon">Public</th><th class="cell-icon">Notes</th><th>Added</th></tr></thead>
    <tbody>
      {{#each samples}}
      <tr data-value="{{./uri}}" data-name="{{name}}">
        <td>{{name}}</td>
        <td class="cell-icon">{{#if active}}<i class="fa fa-check"></i>{{/if}}</td>
        <td class="cell-icon">{{#if public}}<i class="fa fa-check"></i>{{/if}}</td>
        <td class="cell-icon">{{#if notes}}<i class="fa fa-check"></i>{{/if}}</td>
        <td>{{date added}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No samples are here.</p>
{{/if}}
