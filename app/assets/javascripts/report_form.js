const ReportForm = (function() {
  const init = function() {
    $(".flag-form input[type='checkbox']").on('click', function() {
      const $this = $(this);
      const checkboxID = $(this).attr('id');
      const $inputElement = $(`.js-input-field:input[id='${checkboxID}']`);

      // This will update the value as we use same input name for checkbox
      // and text field.
      $inputElement.val('');

      if ($this.is(':checked')) {
        $inputElement.removeClass('hidden');
      } else {
        $inputElement.addClass('hidden');
      }
    });
  };

  return { init: init };
}());

// jQuery
$(document).ready(function () {
  ReportForm.init();
});
