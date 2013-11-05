<table class="table table-striped table-properties">
  <tbody>
    <tr>
      <th scope="row">Original data source</th>
      <td><a href="{{base}}/data_sources/{{escape annotation.original_data_source.uri}}">{{annotation.original_data_source.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Annotated data source</th>
      <td><a href="{{base}}/data_sources/{{escape annotation.annotated_data_source.uri}}">{{annotation.annotated_data_source.name}}</a></td>
    </tr>
    <tr>
      <th scope="row">Written</th>
      <td class="cell-icon">
    {{#if annotation.task.done}}
      <i class="icon-ok"></i>
    {{else}}
      {{#if_eq annotation.task.state compare="failure"}}
        <i class="icon-warning-sign" title="{{annotation.task.error.message}}"></i>
      {{/if_eq}}
      {{#if_eq annotation.task.state compare="started"}}
        <i class="icon-spinner icon-spin"></i>
      {{/if_eq}}
      {{#if_eq annotation.task.state compare="progress"}}
        <div class="progress" title="{{annotation.task.progress}}%">
          <div class="bar" style="width: {{annotation.task.progress}}%;"></div>
        </div>
      {{/if_eq}}
    {{/if}}
      </td>
    </tr>
    <tr>
      <th scope="row">URI</th>
      <td>{{annotation.uri}}</td>
    </tr>
  </tbody>
</dl>
