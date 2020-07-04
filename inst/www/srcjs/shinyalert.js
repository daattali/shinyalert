var swalService = new SwalService({showPendingMessage: false});
shinyalert = {};
shinyalert.indices = [];  // Used to make the timer work

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
      var ii = 0;
      for(ii in shinyalert.indices){
        if( shinyalert.indices[ii] === x ){
          shinyalert.indices.splice( ii, 1 );
        }
        swalService.close( x );
      }
    }, timer, swal_id);
  }

});

Shiny.addCustomMessageHandler('shinyalert.dismiss', function(params) {
  var n = (params && params.count) || shinyalert.indices.length,
      ids = shinyalert.indices.splice(0, n);

  // dismiss n alerts
  var i;
  for( i = 0; i < ids.length; i++ ){
    swalService.close(ids[i]);
  }
});