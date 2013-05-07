<div class="alert alert-{{type}} fade in" data-dismiss="alert">
     {{#if_eq type compare="info"}}<strong>Info</strong>{{/if_eq}}
     {{#if_eq type compare="success"}}<strong>Success</strong>{{/if_eq}}
     {{#if_eq type compare="error"}}<strong>Error</strong>{{/if_eq}}
     {{text}}
</div>
<script>
(function() {
  var currentMessages = $('#messages > div.alert');
  window.setTimeout(function() { currentMessages.alert('close'); }, 3000);
})();
</script>
