# shinyalert 1.0.0.*

- Fixed bug (#19) - alerts with an R callback were very slow when the environment had a large object
- New feature (#12): support chaining modals, you can now call a shinyalert modal in the callback of another modal
- New feature (#11): `inputId` parameter added, which allows you to set the input ID that is used to retrieve the return value of the modal
- Slight documentation changes
- small change to demo shiny app UI
- the return value can now be triggered even if the same input value is used consecutively (only if using shiny version 1.1)

# shinyalert 1.0

2018-02-12

Initial release
