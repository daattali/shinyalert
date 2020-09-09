var swalService = new SwalService({showPendingMessage: false});
shinyalert = {};
shinyalert.instances = [];

Shiny.addCustomMessageHandler('shinyalert.show', function(params) {

  Shiny.unbindAll($(".sweet-alert"));

  var callbackJS = function(value) {};
  if (params['callbackJS'] != null) {
    var cb = params['callbackJS'];
    callbackJS = function(value) { eval("("+cb+")(value)") };
    delete params['callbackJS'];
  }

  var callbackR = function(value) {};
  var cbid = params['cbid'];
  delete params['cbid'];
  if (params['callbackR']) {
    callbackR = function(value) {
      Shiny.onInputChange(cbid, value);
    }
  }

  var callback = function(value) {
    for (var idx in shinyalert.instances) {
      if (shinyalert.instances[idx].cbid === cbid) {
        shinyalert.instances.splice(idx, 1);
      }
      break;
    }

    // Avoid duplicated callback calls
    if (typeof params['inputId'] === 'string') {
      if ('compareVersion' in Shiny && Shiny.compareVersion(Shiny.version, ">=", "1.1.0") ) {
        Shiny.setInputValue(params['inputId'], value, {priority: "event"});
      } else {
        Shiny.onInputChange(params['inputId'], value);
      }
      callbackJS(value);
      callbackR(value);
      delete params['inputId'];
    }
  }

  var timer = params['timer'];
  delete params['timer'];

  var swal_id = swalService.swal(params, callback);
  shinyalert.instances.push({
    swal_id : swal_id,
    cbid    : cbid
  });

  if (timer > 0) {
    setTimeout(function(x) {
      var alertidx = 0;
      for (alertidx in shinyalert.instances) {
        if (shinyalert.instances[alertidx].swal_id === x) {
          shinyalert.instances.splice(alertidx, 1);
        }
        swalService.closeAndFireCallback(x, false);
        break;
      }
    }, timer, swal_id);
  }
});

Shiny.addCustomMessageHandler('shinyalert.closeAlert', function(params) {
  var cbid = params.cbid;
  var idx;

  if (typeof cbid === 'string') {
    // close a specific alert
    for (idx = 0; idx < shinyalert.instances.length; idx++ ){
      var item = shinyalert.instances[idx];
      if (item.cbid === cbid) {
        shinyalert.instances.splice(idx, 1);
        swalService.closeAndFireCallback(item.swal_id, false);
        break;
      }
    }
  } else {
    // close n alerts
    var num = params.count || shinyalert.instances.length;
    var items = shinyalert.instances.splice(0, num);
    for (idx = 0; idx < items.length; idx++) {
      swalService.closeAndFireCallback(items[idx].swal_id, false);
    }
  }
});
