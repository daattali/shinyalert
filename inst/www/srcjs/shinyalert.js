var swalService = new SwalService({showPendingMessage: false});
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
    if ('compareVersion' in Shiny &&
        Shiny.compareVersion(Shiny.version, ">=", "1.1.0") ) {
      Shiny.setInputValue(params['inputId'], value, {priority: "event"});
    } else {
      Shiny.onInputChange(params['inputId'], value);
    }
    callbackJS(value);
    callbackR(value);
    delete params['inputId'];
  }

  if (params['timer'] != 0) {
    setTimeout(function(x) {
      if (x == shinyalert.num) {
        swalService.close();
      }
    }, params['timer'], shinyalert.num);
  }
  delete params['timer'];

  Shiny.unbindAll($(".sweet-alert"));
  swalService.swal(params, callback);
});
