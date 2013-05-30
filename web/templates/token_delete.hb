<form action="{{base}}/tokens/{{escape token.uri}}/delete" method="post">
  <input type="hidden" name="name" id="name" value="{{token.name}}">
  <fieldset>
    <div class="form-actions">
      <button type="submit" class="btn btn-danger"><i class="icon-trash"></i> Revoke API token</button>
      <button type="reset" class="btn">Reset</button>
    </div>
  </fieldset>
</form>
