local M = {}

local function fallback(job)
  return require("archive"):peek(job)
end

function M:peek(job)
  local output = Command("archive-previewer"):arg({ tostring(job.file.path) }):output()
  if not output or not output.status.success or output.stdout == "" then
    return fallback(job)
  end

  local limit = job.area.h
  local count, lines = 0, {}

  for line in output.stdout:gmatch("[^\n]*\n?") do
    if line == "" then
      break
    end

    count = count + 1
    if count > job.skip and count <= job.skip + limit then
      lines[#lines + 1] = line
    end
  end

  if job.skip > 0 and count < job.skip + limit then
    return ya.emit("peek", { math.max(0, count - limit), only_if = job.file.url, upper_bound = true })
  end

  ya.preview_widget(
    job,
    ui.Text.parse(table.concat(lines)):area(job.area):wrap(rt.preview.wrap == "yes" and ui.Wrap.YES or ui.Wrap.NO)
  )
end

function M:seek(job)
  require("code"):seek(job)
end

return M
