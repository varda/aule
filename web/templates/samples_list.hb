{{#if samples}}
  <div class="pagination pagination-centered">
    <ul>
      <li class="disabled"><a href="#">Prev</a></li>
      <li class="active"><a href="#">1</a></li>
      <li><a href="?page=2">2</a></li>
      <li><a href="?page=3">3</a></li>
      <li><a href="?page=4">4</a></li>
      <li><a href="?page=2">Next</a></li>
    </ul>
  </div>
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Name</th></tr></thead>
    <tbody>
      {{#each samples}}
      <tr data-href="/varda-web/samples/{{escape uri}}">
        <td>{{added}}</td>
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  <div class="pagination pagination-centered">
    <ul>
      <li><a href="#">Prev</a></li>
      <li><a href="#">1</a></li>
      <li><a href="#">2</a></li>
      <li><a href="#">3</a></li>
      <li><a href="#">4</a></li>
      <li><a href="#">Next</a></li>
    </ul>
  </div>
{{else}}
  <p>No samples are here.</p>
{{/if}}
