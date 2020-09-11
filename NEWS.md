# shinyalert 2.0.0 (2020-09-11)

- **BREAKING CHANGE** Cannot use `html=TRUE` together with `type="input"`, you must instead supply your own Shiny inputs when using HTML
- **BREAKING CHANGE** When a modal closes automatically due to a timer, it returns `FALSE` (previously nothing was returned)
- New feature: added support for shiny inputs/outputs inside the modal (need to use `html=TRUE`) (#26)
- New feature: added `size` parameter to set the size (width) of the modal to one of four pre-defined sizes (#17)
- New feature: added `immediate` parameter to immediately show the current alert and close all previous alerts
- New feature: added `closeAlert()` function that allows you to close any specific alert (#29)
- `shinyalert()` now returns a unique ID
- Fixed bug where `callbackR` was not respected when the alert had a timer (#38)
- Fixed bug where an alert with a timer caused future alerts to not run (#39)
- Refactor of how unique IDs are created to ensure uniqueness in a performant way

# shinyalert 1.1 (2020-04-29)

- New feature (#11): `inputId` parameter added, which allows you to set the input ID that is used to retrieve the return value of the modal
- New feature (#12): support chaining modals, you can now call a shinyalert modal in the callback of another modal
- Fixed bug (#19) - alerts with an R callback were very slow when the environment had a large object
- New feature (#23): Support using `shinyalert` within Rmarkdown documents
- The return value can now be triggered even if the same input value is used consecutively (only if using shiny version 1.1)
- Documentation changes
- Improvements to demo shiny app UI

# shinyalert 1.0 (2018-02-12)

Initial release
