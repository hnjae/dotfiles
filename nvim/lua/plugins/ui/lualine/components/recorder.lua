return function(options)
  local modules = require("lualine_require").lazy_require({
    recorder = "recorder",
  })
  local ret = {
    [1] = modules.recorder.recordingStatus,
  }

  if
    -- 자체 아이콘 사용
    require("lazy.core.config").plugins["nvim-recorder"].opts.useNerdfontIcons
    or not options.icons_enabled
  then
    return ret
  end

  local icon = " " -- nf-cod-record
  ret.fmt = function(str)
    if str ~= "" then
      return icon .. str
    end

    return str
  end

  return ret
end
