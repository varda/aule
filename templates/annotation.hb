{{#title}}{{annotation.annotated_data_source.name}}{{/title}}

<ul class="nav nav-pills">

<li class="{{#equals subpage 'show'}}active{{/equals}}">
  <a href="{{uri base 'annotations' annotation.uri}}"><i class="fa fa-file"></i> Annotation</a>
</li>

</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'show'}}

<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Original data source</th>
      <td><a href="{{uri base 'data_sources' annotation.original_data_source.uri}}">{{annotation.original_data_source.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Annotated data source</th>
      <td><a href="{{uri base 'data_sources' annotation.annotated_data_source.uri}}">{{annotation.annotated_data_source.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Written</th>
      <td class="cell-icon">
    {{#equals annotation.task.state 'waiting'}}
      <i class="fa fa-spinner fa-spin"></i>
    {{/equals}}
    {{#equals annotation.task.state 'running'}}
      <div class="progress" title="{{annotation.task.progress}}%">
        <div class="bar" style="width: {{annotation.task.progress}}%;"></div>
      </div>
    {{/equals}}
    {{#equals annotation.task.state 'success'}}
      <i class="fa fa-check"></i>
    {{/equals}}
    {{#equals annotation.task.state 'failure'}}
      <i class="fa fa-warning" title="{{annotation.task.error.message}}"></i>
    {{/equals}}
      </td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{annotation.uri}}</td>
    </tr>
  </tbody>
</dl>

{{/inline}}
