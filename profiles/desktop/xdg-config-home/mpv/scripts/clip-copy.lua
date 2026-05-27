local mp = require("mp")
local msg = require("mp.msg")
local utils = require("mp.utils")
local options = require("mp.options")

local opts = {
  output_dir = "~/Videos/mpv-clips",
  container = "mkv",
  align_to_keyframes = true,
  ffmpeg = "ffmpeg",
  ffprobe = "ffprobe",
}

options.read_options(opts, "clip-copy")

local mark_a = nil
local mark_b = nil
local busy = false

local function osd(message)
  mp.osd_message(message, 2.5)
end

local function expand_path(path)
  return utils.get_user_path(path)
end

local function file_exists(path)
  local info = utils.file_info(path)
  return info and info.is_file
end

local function ensure_dir(path)
  local info = utils.file_info(path)
  if info and info.is_dir then
    return true
  end

  local args = { "mkdir", "-p", path }
  local result = mp.command_native({
    name = "subprocess",
    playback_only = false,
    args = args,
    capture_stdout = true,
    capture_stderr = true,
  })

  return result.status == 0
end

local function timestamp(seconds)
  seconds = math.max(0, seconds or 0)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local secs = seconds % 60
  return string.format("%02d:%02d:%06.3f", hours, minutes, secs)
end

local function filename_timestamp(seconds)
  seconds = math.max(0, seconds or 0)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  local secs = math.floor(seconds % 60)
  return string.format("%02d-%02d-%02d", hours, minutes, secs)
end

local function sanitize_filename(name)
  name = name or "clip"
  name = name:gsub("[/%z\1-\31]", "_")
  name = name:gsub("^%s+", ""):gsub("%s+$", "")
  name = name:gsub('[<>:"|?*\\]', "_")
  if name == "" or name == "." or name == ".." then
    name = "clip"
  end
  return name
end

local function basename(path)
  local _, filename = utils.split_path(path)
  return filename
end

local function media_name(path)
  local working_dir = mp.get_property("working-directory", "")
  local normalized = utils.join_path(working_dir, path)
  local filename = basename(normalized) or mp.get_property("media-title", "clip")
  return filename:gsub("%.[^.]+$", "")
end

local function current_time()
  return mp.get_property_number("time-pos")
end

local function set_mark_a()
  mark_a = current_time()
  if not mark_a then
    osd("clip: no playback position")
    return
  end
  osd("clip A: " .. timestamp(mark_a))
end

local function set_mark_b()
  mark_b = current_time()
  if not mark_b then
    osd("clip: no playback position")
    return
  end
  osd("clip B: " .. timestamp(mark_b))
end

local function parse_keyframes(stdout)
  local frames = {}
  for line in (stdout or ""):gmatch("[^\r\n]+") do
    local value = line:match("([%d%.]+)")
    local seconds = tonumber(value)
    if seconds then
      frames[#frames + 1] = seconds
    end
  end
  table.sort(frames)
  return frames
end

local function containing_keyframe_bounds(frames, start_time, end_time)
  if #frames == 0 then
    return start_time, end_time
  end

  -- Expand outward, never inward: the original A-B range must remain fully included.
  local aligned_start = 0
  local aligned_end = end_time

  for _, frame_time in ipairs(frames) do
    if frame_time <= start_time + 0.0005 then
      aligned_start = frame_time
    end
    if frame_time >= end_time - 0.0005 then
      aligned_end = frame_time
      break
    end
  end

  if aligned_end <= aligned_start then
    aligned_end = end_time
  end

  return aligned_start, aligned_end
end

local function make_output_path(source_path, start_time, end_time)
  local output_dir = expand_path(opts.output_dir)
  if not ensure_dir(output_dir) then
    return nil, "could not create output directory: " .. output_dir
  end

  local base = sanitize_filename(media_name(source_path))
  local stem = string.format("%s_%s-%s", base, filename_timestamp(start_time), filename_timestamp(end_time))
  local output = utils.join_path(output_dir, stem .. "." .. opts.container)

  local suffix = 1
  while file_exists(output) do
    output = utils.join_path(output_dir, string.format("%s_%02d.%s", stem, suffix, opts.container))
    suffix = suffix + 1
  end

  return output, nil
end

local function run_ffmpeg(source_path, output_path, start_time, end_time)
  local duration = end_time - start_time
  if duration <= 0 then
    osd("clip: invalid duration")
    busy = false
    return
  end

  local args = {
    opts.ffmpeg,
    "-hide_banner",
    "-loglevel",
    "error",
    "-y",
    "-ss",
    string.format("%.6f", start_time),
    "-i",
    source_path,
    "-t",
    string.format("%.6f", duration),
    "-map",
    "0",
    "-c",
    "copy",
    "-avoid_negative_ts",
    "make_zero",
    output_path,
  }

  osd("clip: writing " .. basename(output_path))

  mp.command_native_async({
    name = "subprocess",
    playback_only = false,
    args = args,
    capture_stdout = true,
    capture_stderr = true,
  }, function(result)
    busy = false
    if result.status == 0 then
      osd("clip saved: " .. output_path)
      msg.info("clip saved: " .. output_path)
    else
      local stderr = (result.stderr or ""):gsub("%s+$", "")
      osd("clip failed; see console")
      msg.error("ffmpeg failed: " .. stderr)
    end
  end)
end

local function export_with_bounds(source_path, start_time, end_time)
  local output_path, err = make_output_path(source_path, start_time, end_time)
  if not output_path then
    osd("clip: " .. err)
    busy = false
    return
  end

  run_ffmpeg(source_path, output_path, start_time, end_time)
end

local function probe_keyframes(source_path, start_time, end_time)
  local args = {
    opts.ffprobe,
    "-v",
    "error",
    "-select_streams",
    "v:0",
    "-skip_frame",
    "nokey",
    "-show_entries",
    "frame=best_effort_timestamp_time,pkt_pts_time,pkt_dts_time",
    "-of",
    "csv=p=0",
    source_path,
  }

  osd("clip: probing keyframes")

  mp.command_native_async({
    name = "subprocess",
    playback_only = false,
    args = args,
    capture_stdout = true,
    capture_stderr = true,
  }, function(result)
    if result.status ~= 0 then
      local stderr = (result.stderr or ""):gsub("%s+$", "")
      msg.warn("ffprobe failed; using original marks: " .. stderr)
      export_with_bounds(source_path, start_time, end_time)
      return
    end

    local frames = parse_keyframes(result.stdout)
    local aligned_start, aligned_end = containing_keyframe_bounds(frames, start_time, end_time)
    msg.info(
      string.format(
        "clip bounds: requested %s-%s, aligned %s-%s",
        timestamp(start_time),
        timestamp(end_time),
        timestamp(aligned_start),
        timestamp(aligned_end)
      )
    )
    export_with_bounds(source_path, aligned_start, aligned_end)
  end)
end

local function export_clip()
  if busy then
    osd("clip: already running")
    return
  end

  local source_path = mp.get_property("path")
  if not source_path then
    osd("clip: no source")
    return
  end

  if not mark_a or not mark_b then
    osd("clip: set A and B first")
    return
  end

  local start_time = math.min(mark_a, mark_b)
  local end_time = math.max(mark_a, mark_b)
  if end_time - start_time <= 0.001 then
    osd("clip: marks are too close")
    return
  end

  busy = true
  if opts.align_to_keyframes then
    probe_keyframes(source_path, start_time, end_time)
  else
    export_with_bounds(source_path, start_time, end_time)
  end
end

mp.add_key_binding("Alt+a", "clip-copy-set-a", set_mark_a)
mp.add_key_binding("Alt+b", "clip-copy-set-b", set_mark_b)
mp.add_key_binding("Alt+c", "clip-copy-export", export_clip)

mp.register_script_message("set-a", set_mark_a)
mp.register_script_message("set-b", set_mark_b)
mp.register_script_message("export", export_clip)
