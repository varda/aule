<form action="{{base}}/lookup_variant" method="post">
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

<label for="chromosome">Chromosome</label>
<select class="input-xlarge" name="chromosome" id="chromosome">
  {{#each chromosomes}}
    <option value="{{this}}">{{this}}</option>
  {{/each}}
</select>

<label for="position">Position</label>
<input type="text" class="input-medium" name="position" id="position">

<label for="reference">Reference sequence</label>
<input type="text" class="input-xlarge" name="reference" id="reference">

<label for="observed">Observed sequence</label>
<input type="text" class="input-xlarge" name="observed" id="observed">

<div class="form-actions">
  <button type="submit" class="btn btn-info"><i class="icon-info"></i> Lookup variant</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>
