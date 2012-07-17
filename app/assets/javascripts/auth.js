$(function() {

  (function (d) {
    var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
    if (d.getElementById(id)) {
      return;
    }
    js = d.createElement('script');
    js.id = id;
    js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js";
    ref.parentNode.insertBefore(js, ref);
  }(document));

  window.fbAsyncInit = function () {
    FB.init({
      appId:'224405887571151',
      channelUrl:'//' + window.location.hostname + '/channel.html',
      status:true,
      cookie:true,
      xfbml:true
    });

    FB.getLoginStatus(function(response) {
      if ( $("#fb-root.logged-in").length) {
        if ( response.status === "unknown" ||
             response.status === "not_authorized" ||
             (response.status === "connected" &&
             response.authResponse.userID != $("#fb-root").data("uid"))) {

          window.location.href = "/logout?fb=true"

        }
      }
    });
  }
});