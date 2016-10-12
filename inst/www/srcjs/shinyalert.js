Shiny.addCustomMessageHandler('shinyalert', function(params) {
  console.log(params);

  var callback = function() {};
  if (params['callback'] != null) {
    callback = function(value) { eval(params['callback']); };
    delete params['callback'];
  }

  if (params['cbid'] != null) {
    var cbid = params['cbid'];
    delete params['cbid'];
    callback = function(value) {
      Shiny.onInputChange(cbid, value);
    }
  }

  swal(params, callback);
});
