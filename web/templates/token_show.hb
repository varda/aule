<dl class="dl-horizontal">
  <dt>Name</dt>
  <dd>{{token.name}}</dd>
  <dt>Added</dd>
  <dd>{{dateFormat token.added}}</dd>
  <dt>URI</dt>
  <dd>{{token.uri}}</dd>
</dl>

<p>
  <button type="button" class="btn btn-warning" data-toggle="modal" data-target="#token-view"><i class="icon-lock"></i> Show token</button>
</p>

<div id="token-view" class="modal hide">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    <h3>{{token.name}}</h3>
  </div>
  <div class="modal-body">
    <pre class="text-center">{{token.key}}</pre>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
