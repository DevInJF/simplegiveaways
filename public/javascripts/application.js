$(function(){
  $.rails.allowAction = function(element) {
    var type = element.data("type");
    var confirmText = element.data("confirm-text") || "Confirm";
    var cancelText = element.data("cancel-text") || "Cancel";
    var message = element.data('confirm'),
        answer = false, callback;

    if (!message) { return true; }

    if ($.rails.fire(element, 'confirm')) {
      sga_confirm(type, message, confirmText, cancelText, function(answer) {
        callback = $.rails.fire(element, 'confirm:complete', [answer]);
        if(callback) {
          $element = element;
          element.removeAttr('data-confirm');
          var oldAllowAction = $.rails.allowAction;
          $.rails.allowAction = function() { return true; };
          $.rails.allowAction = oldAllowAction;
        }
      });
    }
    return false;
  };

  function sga_confirm(type, message, confirm, cancel, callback) {
    var $dialog = $("div.alert-message.block-message");
    var $confirm = $dialog.find(".alert-actions a.btn.confirm");
    var $cancel = $dialog.find(".alert-actions a.btn.cancel");

    $confirm.text(confirm);
    $cancel.text(cancel);
    $dialog.show().addClass(type.toLowerCase()).find("p").html("").prepend("<strong>" + type + "</strong> " + message);

    $confirm.click(function(e){
      callback(message);
      $dialog.fadeOut('slow');
      e.preventDefault();
    });

    $cancel.click(function(e){
      $dialog.fadeOut('slow');
      e.preventDefault();
    });
  }

  $('.alert-message.flash').delay(2800).fadeOut('slow');
  $('.alert-message.flash a.close').click(function(e){
    $('.alert-message.flash').clearQueue();
    $('.alert-message.flash').fadeOut('slow');
    e.preventDefault();
  });
});