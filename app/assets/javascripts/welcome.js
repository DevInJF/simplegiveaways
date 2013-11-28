//= require vendor/jquery-2.0.3.min
//= require vendor/jquery.noisy

$(function() {
  $('body').noisy({
    'intensity' : 0.061,
    'size' : '300',
    'opacity' : 0.08,
    'fallback' : '#DFE3E8',
    'monochrome' : false
  }).css('background-color', '#DFE3E8');
});
