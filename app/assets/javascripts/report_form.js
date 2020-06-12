const ReportForm = (function() {

  const init = function() {
    $(".flag-form input[type='checkbox']").on('click', function() {
      const $this = $(this);
      const checkboxID = $(this).attr('id');
      const $inputElement = $(`.js-input-field:input[id='${checkboxID}']`);

      if ($this.is(':checked')) {
        if ($inputElement.attr('type') === 'email') {
          $inputElement.show();
        } else {
          $inputElement.attr('disabled', false);
        }
      } else {
        if ($inputElement.attr('type') === 'email') {
          $inputElement.hide();
        } else {
          $inputElement.attr('disabled', true);
        }
      }
    });
  };

  return { init: init };

}());

// jQuery
$(document).ready( function () {
  ReportForm.init();
});
