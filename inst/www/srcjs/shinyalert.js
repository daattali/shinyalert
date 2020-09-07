var swalService = new SwalService({showPendingMessage: false});
shinyalert = {};
shinyalert.indices = [];  // Used to make the timer work

Shiny.addCustomMessageHandler('shinyalert.show', function(params) {

  Shiny.unbindAll($(".sweet-alert"));

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

  var timer = params['timer'];
  delete params['timer'];

  var swal_id = swalService.swal(params, callback);
  shinyalert.indices.push(swal_id);

  if (timer != 0) {
    setTimeout(function(x) {
      var alertidx = 0;
      for (alertidx in shinyalert.indices) {
        if (shinyalert.indices[alertidx] === x) {
          shinyalert.indices.splice(alertidx, 1);
        }
        swalService.close(x);
      }
    }, timer, swal_id);
  }
});
