Shiny.addCustomMessageHandler('shinyalert', function(params) {
  console.log(params);

  var callback = function() {};
  if (params['callback'] != null) {
    callback = function(value) { eval(params['callback']); };
    delete params['callback'];
  }

  swal(params, callback);
});
