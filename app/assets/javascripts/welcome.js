//= require jquery
//= require ../../../vendor/assets/javascripts/jquery.noisy

$(function() {
  $('body').noisy({
    'intensity' : 0.061,
    'size' : '300',
    'opacity' : 0.08,
    'fallback' : '#DFE3E8',
    'monochrome' : false
  }).css('background-color', '#DFE3E8');
});
