-- SPDX-License-Identifier: AGPL-3.0-or-later
-- SPDX-FileCopyrightText: 2022-2026 KIM Hyunjae

local M = {}

-- Width of the left-hand label column of the video info block.
local LABEL_WIDTH = 10

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

-- The same data as above, structured, so that a video preview can show a few
-- key rows under its thumbnail instead of the whole report.
local function mediainfo_tracks(path)
  local output, err = Command("mediainfo"):arg({ "--Output=JSON", "--", path }):output()
  if not output then
    return nil, tostring(err)
  end

  local data = ya.json_decode(output.stdout)
  if type(data) ~= "table" or type(data.media) ~= "table" then
    return nil, "mediainfo returned no JSON"
  end
  if type(data.media.track) ~= "table" then
    return nil, "mediainfo returned no tracks"
  end

  return data.media.track, nil
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

-- Drop the nils, so that a partially known track still yields a short row.
local function list(...)
  local out = {}
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    if value then
      out[#out + 1] = value
    end
  end
  return out
end

local function join(parts)
  return table.concat(parts, " · ")
end

local function format_length(seconds)
  local total = tonumber(seconds)
  if not total then
    return nil
  end

  total = math.floor(total + 0.5)
  local hours = math.floor(total / 3600)
  local minutes = math.floor(total % 3600 / 60)

  if hours > 0 then
    return string.format("%d:%02d:%02d", hours, minutes, total % 60)
  end
  return string.format("%d:%02d", minutes, total % 60)
end

local function format_bitrate(bits)
  local rate = tonumber(bits)
  if not rate or rate <= 0 then
    return nil
  elseif rate >= 1e6 then
    return string.format("%.1f Mb/s", rate / 1e6)
  elseif rate >= 1e3 then
    return string.format("%.0f kb/s", rate / 1e3)
  end
  return string.format("%d b/s", rate)
end

local function format_rate(rate)
  local fps = tonumber(rate)
  if not fps or fps <= 0 then
    return nil
  elseif math.abs(fps - math.floor(fps + 0.5)) < 0.001 then
    return string.format("%d fps", math.floor(fps + 0.5))
  end
  return string.format("%.3f fps", fps)
end

local function format_codec(track)
  local format = track.Format
  if not format then
    return nil
  end

  local profile = track.Format_Profile
  if profile and profile ~= "" then
    return format .. " " .. profile
  end
  return format
end

local function format_resolution(track)
  if not track.Width or not track.Height then
    return nil
  end
  return string.format("%sx%s", track.Width, track.Height)
end

local function format_channels(track)
  local channels = tonumber(track.Channels)
  if not channels then
    return nil
  end
  return string.format("%d ch", channels)
end

local function general_length(tracks)
  for _, track in ipairs(tracks) do
    if track["@type"] == "General" then
      return tonumber(track.Duration)
    end
  end
end

local function video_rows(tracks)
  local rows, counts = {}, {}

  local function add(kind, label, parts)
    if #parts == 0 then
      return
    end

    counts[kind] = (counts[kind] or 0) + 1
    rows[#rows + 1] = {
      counts[kind] == 1 and label or "",
      join(parts),
    }
  end

  for _, track in ipairs(tracks) do
    if track["@type"] == "General" then
      add(
        "length",
        "Length",
        list(format_length(track.Duration), format_bitrate(track.OverallBitRate))
      )
      break
    end
  end

  for _, track in ipairs(tracks) do
    local kind = track["@type"]
    if kind == "Video" then
      add(
        "video",
        "Video",
        list(
          format_codec(track),
          format_resolution(track),
          format_rate(track.FrameRate),
          format_bitrate(track.BitRate)
        )
      )
    elseif kind == "Audio" then
      add(
        "audio",
        "Audio",
        list(format_codec(track), format_channels(track), format_bitrate(track.BitRate))
      )
    end
  end

  -- Subtitles share one row: a file can carry dozens of them.
  local names, seen, total = {}, {}, 0
  for _, track in ipairs(tracks) do
    if track["@type"] == "Text" then
      total = total + 1
      local name = track.Language or track.Title or track.Format or "?"
      if not seen[name] then
        seen[name] = true
        names[#names + 1] = name
      end
    end
  end
  if total > 0 then
    local value = table.concat(names, ", ")
    if total > 1 then
      value = string.format("%s (%d tracks)", value, total)
    end
    rows[#rows + 1] = { "Subtitles", value }
  end

  return rows
end

-- Render the info rows as text lines, label column aligned.
local function info_lines(rows)
  local lines = {}
  for _, row in ipairs(rows) do
    lines[#lines + 1] = ui.Line(string.format("%-" .. LABEL_WIDTH .. "s%s", row[1], row[2]))
  end
  return lines
end

-- The built-in `video` preloader fills the same cache file; grabbing a frame
-- slightly into the video is better than the first one, which is often black.
local function thumbnail(job, length)
  local cache = ya.file_cache(job)
  if not cache then
    return nil
  end

  local cha = fs.cha(cache)
  if cha and cha.len > 0 then
    return cache
  end

  local function grab(offset)
    local cmd = Command("ffmpeg"):arg({
      "-v",
      "error",
      "-hwaccel",
      "auto",
      "-threads",
      1,
      "-an",
      "-sn",
      "-dn",
    })
    if offset > 0 then
      cmd = cmd:arg({ "-ss", string.format("%.3f", offset) })
    end

    local output = cmd
      :arg({ "-i", tostring(job.file.path) })
      :arg({ "-map", "0:v:0", "-vframes", 1 })
      :arg({
        "-vf",
        string.format(
          "scale='min(%d,iw)':'min(%d,ih)':force_original_aspect_ratio=decrease:flags=fast_bilinear",
          rt.preview.max_width,
          rt.preview.max_height
        ),
      })
      :arg({ "-q:v", tostring(31 - math.floor(rt.preview.image_quality * 0.3)) })
      :arg({ "-f", "image2", "-y", tostring(cache) })
      :output()

    return output and output.status.success
  end

  local offset = (length or 0) * 0.05
  if grab(offset) or (offset > 0 and grab(0)) then
    return cache
  end
  return nil
end

function M:peek_text(job)
  local content, err = mediainfo(tostring(job.file.path))
  if not content then
    content = "Failed to run mediainfo: " .. err .. "\n"
  end

  local limit = job.area.h
  local count, lines = visible_lines(content, job.skip, limit)

  if job.skip > 0 and count < job.skip + limit then
    return ya.emit(
      "peek",
      { math.max(0, count - limit), only_if = job.file.url, upper_bound = true }
    )
  end

  ya.preview_widget(
    job,
    ui.Text
      .parse(table.concat(lines))
      :area(job.area)
      :wrap(rt.preview.wrap == "yes" and ui.Wrap.YES or ui.Wrap.NO)
  )
end

-- A thumbnail with a few key rows of `mediainfo` under it. The image goes to
-- its own channel and the text to the widget channel, so both show at once:
-- drawing the widgets clears the area, hence the image is shown again last.
function M:peek_video(job)
  local tracks = mediainfo_tracks(tostring(job.file.path))
  local rows = tracks and video_rows(tracks) or {}
  if #rows == 0 then
    return M:peek_text(job)
  end

  local area = job.area
  local lines = { ui.Line("") }
  for _, line in ipairs(info_lines(rows)) do
    lines[#lines + 1] = line
  end

  -- The seek keys scroll the info block; the thumbnail keeps its place.
  local skip = math.min(job.skip, #lines - 1)
  local block = {}
  for i = skip + 1, #lines do
    block[#block + 1] = lines[i]
  end

  local reserved = math.min(#block, math.max(0, area.h - 1))
  local image_h = area.h - reserved
  local image_area = ui.Rect({ x = area.x, y = area.y, w = area.w, h = image_h })

  -- Show the image once to learn the rows it actually takes, so that the info
  -- block sits right under it instead of at the bottom of a mostly empty pane.
  -- A driver that is still warming up reports the whole area instead, so the
  -- block always keeps the rows reserved for it.
  local cache = thumbnail(job, general_length(tracks))
  local shown = cache and ya.image_show(cache, image_area)

  local text_y = area.y + image_h
  if shown and shown.y + shown.h < text_y then
    text_y = shown.y + shown.h
  end
  local text_h = math.max(0, area.h - (text_y - area.y))

  local widgets = {}
  if text_h > 0 then
    widgets[#widgets + 1] = ui.Text(block)
      :area(ui.Rect({ x = area.x, y = text_y, w = area.w, h = text_h }))
      :wrap(ui.Wrap.NO)
  end

  ya.preview_widget(job, widgets)

  if cache then
    local _, err = ya.image_show(cache, image_area)
    if err then
      ya.err(string.format("Failed to show the video thumbnail: %s", err))
    end
  end
end

function M:peek(job)
  if job.mime and job.mime:match("^video/") then
    return M:peek_video(job)
  end
  return M:peek_text(job)
end

function M:seek(job)
  require("code"):seek(job)
end

return M
