{{#title}}Frequency lookup{{/title}}

<ul class="nav nav-pills">
  <li{{#equals subpage 'variant'}} class="active"{{/equals}}><a href="{{uri base 'lookup_variant'}}"><i class="fa fa-comment"></i> By variant</a></li>
  <li{{#equals subpage 'region'}} class="active"{{/equals}}><a href="{{uri base 'lookup_region'}}"><i class="fa fa-comments"></i> By region</a></li>
  {{#if query_by_transcript }}
    <li{{#equals subpage 'transcript'}} class="active"{{/equals}}><a href="{{uri base 'lookup_transcript'}}"><i class="fa fa-comments"></i> By transcript</a></li>
  {{/if}}
</ul>

{{> (lookup . 'subpage') }}


{{#*inline 'region'}}

<form action="{{uri base 'variants'}}" method="get">
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
  <a href="{{uri base 'picker' 'samples'}}" class="picker-open">Choose a sample...</a>
{{else}}
  <a href="{{uri base 'picker' 'samples' filter='public'}}" class="picker-open">Choose a sample (public samples)...</a>
  {{#if auth}}
    <a href="{{uri base 'picker' 'samples' filter='own'}}" class="picker-open">Choose a sample (my samples)...</a>
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
        <a href="{{uri base 'picker' 'groups'}}" class="picker-open">Choose a group...</a>
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

<label for="begin">Region begin</label>
<input type="text" class="input-small" name="begin" id="begin">

<label for="end">Region end</label>
<input type="text" class="input-small" name="end" id="end">

<div class="form-actions">
  <button type="submit" class="btn btn-info"><i class="fa fa-info"></i> Lookup region</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>

{{/inline}}


{{#*inline 'transcript'}}

<form action="{{uri base 'variants'}}" method="get">
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
  <a href="{{uri base 'picker' 'samples'}}" class="picker-open">Choose a sample...</a>
{{else}}
  <a href="{{uri base 'picker' 'samples' filter='public'}}" class="picker-open">Choose a sample (public samples)...</a>
  {{#if auth}}
    <a href="{{uri base 'picker' 'samples' filter='own'}}" class="picker-open">Choose a sample (my samples)...</a>
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
        <a href="{{uri base 'picker' 'groups'}}" class="picker-open">Choose a group...</a>
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
    <a href="{{uri base 'picker' 'transcripts'}}" class="picker-open">Choose a transcript...</a>
  </div>
</div>

<div class="form-actions">
  <button type="submit" class="btn btn-info"><i class="fa fa-info"></i> Lookup transcript</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>

{{/inline}}


{{#*inline 'variant'}}

<form action="{{uri base 'lookup_variant'}}" method="post">
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
  <a href="{{uri base 'picker' 'samples'}}" class="picker-open">Choose a sample...</a>
{{else}}
  <a href="{{uri base 'picker' 'samples' filter='public'}}" class="picker-open">Choose a sample (public samples)...</a>
  {{#if auth}}
    <a href="{{uri base 'picker' 'samples' filter='own'}}" class="picker-open">Choose a sample (my samples)...</a>
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
        <a href="{{uri base 'picker' 'groups'}}" class="picker-open">Choose a group...</a>
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
  <button type="submit" class="btn btn-info"><i class="fa fa-info"></i> Lookup variant</button>
  <button type="reset" class="btn">Reset</button>
</div>

  </fieldset>
</form>

{{/inline}}
