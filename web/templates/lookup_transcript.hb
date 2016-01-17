<form action="{{base}}/variants" method="get">
  <fieldset>

{{#if auth.rights.global_query}}
  <label>Query</label>
  <label class="radio">
    <input type="radio" name="query" value="global" checked="checked"> Global query
  </label>
{{/if}}

<label class="radio">
  <input type="radio" name="query" value="sample"{{#if auth.rights.global_query}}{{else}} checked="checked"{{/if}}> Sample query<br>
  <div class="form-picker input-xlarge" data-name="sample">
    <div>
{{#if auth.rights.list_samples}}
  <a href="{{base}}/picker/samples" class="picker-open">Choose a sample...</a>
{{else}}
  <a href="{{base}}/picker/samples?filter=public" class="picker-open">Choose a sample (public samples)...</a>
  {{#if auth}}
    <a href="{{base}}/picker/samples?filter=own" class="picker-open">Choose a sample (my samples)...</a>
  {{/if}}
{{/if}}
    </div>
  </div>
</label>

{{#if auth.rights.group_query}}
  <label class="radio">
    <input type="radio" name="query" value="group"> Group query<br>
    <div class="form-picker input-xlarge" data-name="group">
      <div>
        <a href="{{base}}/picker/groups" class="picker-open">Choose a group...</a>
      </div>
    </div>
  </label>
{{/if}}

{{#if auth.rights.query}}
  <label class="radio">
    <input type="radio" name="query" value="custom"> Custom query<br>
    <input type="text" class="input-xxlarge" name="custom">
  </label>
{{/if}}

<label for="transcript">Transcript</label>
<div class="form-picker input-xlarge" data-name="transcript">
  <div>
    <a href="{{base}}/picker/transcripts" class="picker-open">Choose a transcript...</a>
  </div>
</div>

<div class="form-actions">
  <button type="submit" class="btn btn-info"><i class="icon-info"></i> Lookup transcript</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>
