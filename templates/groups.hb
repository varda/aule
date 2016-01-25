{{#title}}Groups{{/title}}

{{#if auth.rights.add_group}}
  <ul class="nav nav-pills">
    <li class="{{#equals subpage 'list'}}active{{/equals}}">
      <a href="{{uri base 'groups'}}"><i class="fa fa-th"></i> All groups</a>
    </li>
    <li class="pull-right{{#equals subpage 'add'}} active{{/equals}}">
      <a href="{{uri base 'groups_add'}}"><i class="fa fa-plus"></i> Add group</a>
    </li>
  </ul>
{{/if}}

{{> (lookup . 'subpage') }}


{{#*inline 'add'}}

<form action="{{uri base 'groups'}}" method="post">
  <fieldset>
    <label for="name">Group name</label>
    <input type="text" class="input-xlarge" name="name" id="name">
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="fa fa-plus"></i> Add group</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>

{{/inline}}


{{#*inline 'list'}}

{{#if groups}}
  {{> pagination}}
  <table class="table table-hover">
    <thead><tr><th>Name</th></tr></thead>
    <tbody>
      {{#each groups}}
      <tr data-href="{{uri ../base 'groups' ./uri}}">
        <td>{{name}}</td>
      </tr>
      {{/each}}
    </tbody>
  </table>
  {{> pagination}}
{{else}}
  <p>No groups are here.</p>
{{/if}}

{{/inline}}
