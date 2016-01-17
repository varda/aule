{{#pickerTitle}}Choose a transcript{{/pickerTitle}}

<label for="query">Search query (e.g., <code>cdk2</code> or <code>tumor suppressor</code> or <code>NM_001798</code>)</label>
<input type="text" class="input-xlarge transcript-querier">

<script>
// Sorry, this is a bit messy. Alternatively, we could do something like the
// following globally, but that will be triggered quite often:
//   $(document).on 'DOMNodeInserted', -> $('.transcript-querier').focus()
$('#picker .transcript-querier').focus()
</script>

<div id="transcript-query"></div>
