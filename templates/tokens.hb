{{#title}}API tokens{{/title}}

<ul class="nav nav-pills">

<li class="{{#equals subpage 'list'}}active{{/equals}}">
  <a href="{{uri base 'tokens'}}"><i class="fa fa-th"></i> My API tokens</a>
</li>

<li class="pull-right{{#equals subpage 'add'}} active{{/equals}}">
  <a href="{{uri base 'tokens_add'}}"><i class="fa fa-plus"></i> Generate API token</a>
</li>

</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'add'}}

<form action="{{uri base 'tokens'}}" method="post">
  <fieldset>
    <label for="name">API token name</label>
    <input type="text" class="input-xlarge" name="name" id="name">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Generate API token</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'list'}}

{{#if tokens}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Added</th><th>Name</th></tr></thead>
    <tbody>
      {{#each tokens}}
      <tr data-href="{{uri ../base 'tokens' ./uri}}">
        <td>{{date added}}</td>
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No API tokens are here.</p>
{{/if}}

{{/inline}}
