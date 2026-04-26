local M = {}

local function mediainfo(path)
  local output, err = Command("mediainfo"):arg({ "--", path }):output()
  if not output then
    return nil, tostring(err)
  end

  local content = output.stdout
  if output.stderr ~= "" then
    if content ~= "" and not content:match("\n$") then
      content = content .. "\n"
    end
    content = content .. output.stderr
  end

  if content == "" then
    return nil, "mediainfo returned no output"
  end

  return content, nil
end

local function visible_lines(content, skip, limit)
  local count, lines = 0, {}

  for line in content:gmatch("[^\n]*\n?") do
    if line == "" then
      break
    end

    count = count + 1
    if count > skip and count <= skip + limit then
      lines[#lines + 1] = line
    end
  end

  return count, lines
end

function M:peek(job)
  local content, err = mediainfo(tostring(job.file.path))
  if not content then
    content = "Failed to run mediainfo: " .. err .. "\n"
  end

  local limit = job.area.h
  local count, lines = visible_lines(content, job.skip, limit)

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
