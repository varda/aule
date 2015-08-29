{{#pickerTitle}}Choose a group{{/pickerTitle}}

{{#if groups}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th></tr></thead>
    <tbody>
      {{#each groups}}
      <tr data-uri="{{uri}}" data-name="{{name}}">
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No groups are here.</p>
{{/if}}
