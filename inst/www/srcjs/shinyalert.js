Shiny.addCustomMessageHandler('shinyalert.show', function(params) {
  var callbackJS = function(value) {};
  if (params['callbackJS'] != null) {
    var cb = params['callbackJS'];
    callbackJS = function(value) { eval("("+cb+")(value)") };
    delete params['callbackJS'];
  }

  var callbackR = function(value) {};
  if (params['cbid'] != null) {
    var cbid = params['cbid'];
    delete params['cbid'];
    callbackR = function(value) {
      Shiny.onInputChange(cbid, value);
    }
  }

  var callback = function(value) {
    Shiny.onInputChange(params['returnId'], value);
    callbackJS(value);
    callbackR(value);
    delete params['returnId'];
  }

  swal(params, callback);
});

Shiny.addCustomMessageHandler('shinyalert.close', function(message) {
  swal.close();
});
