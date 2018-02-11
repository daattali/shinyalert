shinyalert = {};
shinyalert.num = 0;  // Used to make the timer work

Shiny.addCustomMessageHandler('shinyalert.show', function(params) {
  shinyalert.num++;

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

  if (params['timer'] != 0) {
    setTimeout(function(x) {
      if (x == shinyalert.num) {
        swal.close();
      }
    }, params['timer'], shinyalert.num);
  }
  delete params['timer'];

  swal(params, callback);
});

Shiny.addCustomMessageHandler('shinyalert.close', function(message) {
  swal.close();
});
