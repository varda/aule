<div class="alert alert-{{type}} fade in" data-dismiss="alert">
     {{#equals type 'info'}}<strong>Info</strong>{{/equals}}
     {{#equals type 'success'}}<strong>Success</strong>{{/equals}}
     {{#equals type 'error'}}<strong>Error</strong>{{/equals}}
     {{text}}
</div>
