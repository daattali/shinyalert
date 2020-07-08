var swalService = new SwalService({showPendingMessage: false});
shinyalert = {};
shinyalert.instances = [];  // Used to make the timer work

Shiny.addCustomMessageHandler('shinyalert.show', function(params) {

  var callbackJS = function(value) {};
  if (params['callbackJS'] != null) {
    var cb = params['callbackJS'];
    callbackJS = function(value) { eval("("+cb+")(value)") };
    delete params['callbackJS'];
  }

  var callbackR = function(value) {};
  // Always create cbid
  var cbid = params['cbid'];
  delete params['cbid'];
  if(typeof cbid === 'string'){
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
  shinyalert.instances.push({
    swal_id : swal_id,
    cbid    : cbid
  });

  // Changed timer != 0 to timer > 0
  if (timer > 0) {
    setTimeout(function(x) {
      var ii = 0;
      for(ii in shinyalert.instances){
        if( shinyalert.instances[ii].swal_id === x ){
          shinyalert.instances.splice( ii, 1 );
        }
        swalService.close( x );
        break;
      }
    }, timer, swal_id);
  }

});

Shiny.addCustomMessageHandler('shinyalert.close', function(params) {
  var n = (params && params.count) || shinyalert.instances.length,
      cbid = params.cbid;

  var i, item;
  if( typeof cbid === 'string' ){
    // close specific alert
    for( i = 0; i < shinyalert.instances.length; i++ ){
      item = shinyalert.instances[i];
      if( item.cbid === cbid ){
        swalService.close( item.swal_id );
        shinyalert.instances.splice( i, 1 );
        break;
      }
    }
  } else {
    // dismiss n alerts
    item = shinyalert.instances.splice(0, n);
    for( i = 0; i < item.length; i++ ){
      swalService.close( item[i].swal_id );
    }
  }

});