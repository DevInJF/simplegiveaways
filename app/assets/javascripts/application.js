$(function(){

  // Override the default confirmation dialog
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
          var oldAllowAction = $.rails.allowAction;
          $.rails.allowAction = function() { return true; };
          element.trigger('click');
          $.rails.allowAction = oldAllowAction;
        }
      });
    }
    return false;
  };

  // Build the custom confirmation dialog
  function sga_confirm(type, message, confirm, cancel, callback) {
    var $mask = $("div.message-mask");
    var $dialog = $("div.alert-message.block-message");
    var $confirm = $dialog.find(".alert-actions a.btn.confirm");
    var $cancel = $dialog.find(".alert-actions a.btn.cancel");

    $confirm.text(confirm);
    $cancel.text(cancel);
    $mask.show();
    $dialog.show().addClass(type.toLowerCase()).find("p").html("").prepend("<strong>" + type + "</strong> " + message);

    $confirm.click(function(e){
      callback(message);
      fade_dialogs();
      e.preventDefault();
    });

    $cancel.click(function(e){
      fade_dialogs();
      e.preventDefault();
    });

    $mask.css("height", $(document).height());
    $(window).bind("resize", function(){
      $mask.css("height", $(window).height());
    });

    function fade_dialogs() {
      $dialog.fadeOut(200);
      $mask.fadeOut(200);
    }
  }

  // Flash behaviors
  $('.alert-message.flash').delay(2800).fadeOut('slow');
  $('.alert-message.flash a.close').click(function(e){
    $('.alert-message.flash').clearQueue();
    $('.alert-message.flash').fadeOut('slow');
    e.preventDefault();
  });

  // Tab behaviors
  $('ul.tabs li a').click(function(e){
    var current_section = "#" + $('ul.tabs li.active a').attr('class');
    var next_section = "#" + $(this).attr('class');

    $('section' + current_section).removeClass('active');
    $('section' + next_section).addClass('active');

    $(this).parent('ul.tabs li').siblings('.active').removeClass('active');
    $(this).parent('li').addClass('active');

    e.preventDefault();
  });
});