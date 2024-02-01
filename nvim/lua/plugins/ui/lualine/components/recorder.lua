local modules = require("lualine_require").lazy_require({
  recorder = "recorder",
})

return {
  [1] = modules.recorder.recordingStatus,
}
