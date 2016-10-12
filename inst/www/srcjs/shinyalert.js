Shiny.addCustomMessageHandler('shinyalert', function(params) {
  console.log(params);
  swal(params);
});
