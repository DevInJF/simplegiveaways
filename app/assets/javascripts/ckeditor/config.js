CKEDITOR.editorConfig = function(config) {
  config.toolbar_Basic = [
    { name: 'links', items : [ 'Link', 'Unlink' ] },
    { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', '-', 'RemoveFormat' ] },
    { name: 'colors', items : [ 'TextColor', 'BGColor' ] },
    { name: 'styles', items: [ 'Format', 'Font', 'FontSize' ] }
  ];
  config.toolbar = 'Basic';
}
