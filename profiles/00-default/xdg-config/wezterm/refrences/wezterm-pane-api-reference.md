# WezTerm Pane API 완전 참조

**구현 위치**: `lua-api-crates/mux/src/pane.rs`

## 목차

1. [기본 정보](#기본-정보)
2. [텍스트 입력 메서드](#텍스트-입력-메서드)
3. [정보 조회 메서드](#정보-조회-메서드)
4. [텍스트 읽기 메서드](#텍스트-읽기-메서드)
5. [Semantic Zone 메서드](#semantic-zone-메서드)
6. [Pane 조작 메서드](#pane-조작-메서드)
7. [반환 객체 타입](#반환-객체-타입)
8. [사용 예시](#사용-예시)

---

## 기본 정보

### `pane:pane_id()`

**라인**: 94

Pane의 고유 ID를 반환합니다.

```lua
local id = pane:pane_id()
-- 반환: 숫자 (PaneId)
```

### `pane:mux_pane()`

**라인**: 141

MuxPane 객체 자신을 반환합니다 (후방 호환성).

```lua
local mux_pane = pane:mux_pane()
```

---

## 텍스트 입력 메서드

### `pane:send_paste(text)`

**라인**: 100-106

텍스트를 paste 모드로 전송합니다 (bracketed paste).

```lua
pane:send_paste('echo "hello world"\n')
```

### `pane:paste(text)`

**라인**: 110-116

`send_paste`의 별칭 (후방 호환성).

```lua
pane:paste('text to paste')
```

### `pane:send_text(text)`

**라인**: 118-125

텍스트를 그대로 전송합니다 (raw).

```lua
pane:send_text('ls -la\n')
```

### `pane:inject_output(text)`

**라인**: 293-303

터미널 출력에 escape sequence를 직접 주입합니다.

```lua
-- 빨간색 텍스트 출력
pane:inject_output('\x1b[31mRed Text\x1b[0m')
```

---

## 정보 조회 메서드

### `pane:get_title()`

**라인**: 143-147

Pane의 제목을 반환합니다.

```lua
local title = pane:get_title()
-- 반환: 문자열
```

### `pane:get_domain_name()`

**라인**: 277-291

Pane이 속한 domain의 이름을 반환합니다.

```lua
local domain = pane:get_domain_name()
-- 반환: "local", "SSH to user@host", "my-server" 등
```

### `pane:get_current_working_dir()`

**라인**: 156-162

현재 작업 디렉토리를 반환합니다 (OSC 7 또는 프로세스 정보 기반).

```lua
local cwd_url = pane:get_current_working_dir()
if cwd_url then
  local cwd = cwd_url.file_path  -- URL 객체
  wezterm.log_info('CWD: ' .. cwd)
end
-- 반환: Url 객체 또는 nil
```

### `pane:get_foreground_process_name()`

**라인**: 171-175

전경 프로세스의 실행 파일 경로를 반환합니다.

```lua
local process = pane:get_foreground_process_name()
-- 반환: "/bin/bash", "/usr/bin/vim" 등 (문자열 또는 nil)
```

### `pane:get_foreground_process_info()`

**라인**: 177-181

전경 프로세스의 상세 정보를 반환합니다.

```lua
local info = pane:get_foreground_process_info()
if info then
  wezterm.log_info('PID: ' .. info.pid)
  wezterm.log_info('Name: ' .. info.name)
  wezterm.log_info('Executable: ' .. info.executable)
end
-- 반환: 테이블 { pid, name, executable, ... } 또는 nil
```

### `pane:get_cursor_position()`

**라인**: 183-187

커서 위치를 반환합니다.

```lua
local cursor = pane:get_cursor_position()
wezterm.log_info('X: ' .. cursor.x .. ', Y: ' .. cursor.y)
-- 반환: { x = 숫자, y = 숫자, ... }
```

### `pane:get_dimensions()`

**라인**: 189-193

Pane의 크기 정보를 반환합니다.

```lua
local dims = pane:get_dimensions()
wezterm.log_info('Cols: ' .. dims.cols)
wezterm.log_info('Rows: ' .. dims.viewport_rows)
-- 반환: {
--   cols = 숫자,              -- 가로 크기 (문자 단위)
--   viewport_rows = 숫자,     -- 보이는 세로 크기
--   physical_top = 숫자,      -- 스크롤백 기준 시작 위치
--   scrollback_rows = 숫자,   -- 스크롤백 크기
--   ...
-- }
```

### `pane:get_user_vars()`

**라인**: 195-199

사용자 정의 변수들을 반환합니다 (OSC 1337 SetUserVar).

```lua
local vars = pane:get_user_vars()
for key, value in pairs(vars) do
  wezterm.log_info(key .. ': ' .. value)
end
-- 반환: 테이블 { key = value, ... }
```

### `pane:get_metadata()`

**라인**: 164-169

Pane의 메타데이터를 반환합니다.

```lua
local metadata = pane:get_metadata()
-- SSH 연결 지연시간 확인
if metadata.since_last_response_ms then
  wezterm.log_info('Lag: ' .. metadata.since_last_response_ms .. 'ms')
end
-- 반환: 동적 테이블
```

### `pane:get_progress()`

**라인**: 149-154

진행 상황 정보를 반환합니다 (OSC 9;4 progress indicator).

```lua
local progress = pane:get_progress()
-- 반환: 진행률 정보 테이블 또는 nil
```

### `pane:has_unseen_output()`

**라인**: 201-205

마지막 포커스 이후 새 출력이 있었는지 확인합니다.

```lua
if pane:has_unseen_output() then
  wezterm.log_info('New output detected!')
end
-- 반환: boolean
```

### `pane:is_alt_screen_active()`

**라인**: 207-211

대체 화면 버퍼가 활성화되어 있는지 확인합니다 (vim, less 등에서 사용).

```lua
if pane:is_alt_screen_active() then
  wezterm.log_info('Alt screen is active (vim, less, etc.)')
end
-- 반환: boolean
```

### `pane:get_tty_name()`

**라인**: 431-435

TTY 장치 이름을 반환합니다.

```lua
local tty = pane:get_tty_name()
-- 반환: "/dev/ttys001" 등 (문자열 또는 nil)
```

---

## 텍스트 읽기 메서드

### `pane:get_lines_as_text([nlines])`

**라인**: 218-238

Viewport의 텍스트를 평문으로 반환합니다 (escape sequence 제거).

```lua
-- 현재 viewport 전체
local text = pane:get_lines_as_text()

-- 마지막 10줄
local text = pane:get_lines_as_text(10)

-- 반환: 문자열 (trailing whitespace 제거됨)
```

**매개변수**:
- `nlines` (선택): 읽을 줄 수. 생략 시 viewport 전체.

### `pane:get_lines_as_escapes([nlines])`

**라인**: 240-250

Viewport의 텍스트를 escape sequence 포함하여 반환합니다.

```lua
local text_with_colors = pane:get_lines_as_escapes(20)
-- 반환: 색상/스타일 정보를 포함한 문자열
```

**매개변수**:
- `nlines` (선택): 읽을 줄 수.

### `pane:get_logical_lines_as_text([nlines])`

**라인**: 252-275

논리적 줄 단위로 텍스트를 반환합니다 (줄바꿈된 긴 줄을 하나로 처리).

```lua
local text = pane:get_logical_lines_as_text()
-- 반환: 논리적 줄로 재구성된 문자열
```

**매개변수**:
- `nlines` (선택): 읽을 줄 수.

---

## Semantic Zone 메서드

Semantic Zone은 터미널의 의미론적 영역 (출력, 입력, 프롬프트 등)을 나타냅니다.

### `pane:get_semantic_zones([of_type])`

**라인**: 305-321

Semantic zone 목록을 반환합니다.

```lua
-- 모든 zone
local zones = pane:get_semantic_zones()

-- 특정 타입만 (Output, Prompt, Input 등)
local output_zones = pane:get_semantic_zones('Output')

for _, zone in ipairs(zones) do
  wezterm.log_info('Zone: ' .. zone.semantic_type)
  wezterm.log_info('  Start: (' .. zone.start_x .. ', ' .. zone.start_y .. ')')
  wezterm.log_info('  End: (' .. zone.end_x .. ', ' .. zone.end_y .. ')')
end

-- 반환: 테이블 배열
-- [
--   {
--     semantic_type = "Output",
--     start_x = 숫자,
--     start_y = 숫자,
--     end_x = 숫자,
--     end_y = 숫자
--   },
--   ...
-- ]
```

**매개변수**:
- `of_type` (선택): 필터링할 타입
  - `"Output"` - 명령 출력
  - `"Prompt"` - 프롬프트
  - `"Input"` - 사용자 입력

**참고**: Shell integration 설정 필요 (OSC 133 시퀀스).

### `pane:get_semantic_zone_at(x, y)`

**라인**: 323-362

지정한 좌표에 있는 semantic zone을 반환합니다.

```lua
local zone = pane:get_semantic_zone_at(10, 5)
if zone then
  wezterm.log_info('Found zone: ' .. zone.semantic_type)
end
-- 반환: zone 테이블 또는 nil
```

**매개변수**:
- `x`: X 좌표 (0부터 시작)
- `y`: Y 좌표 (StableRowIndex)

### `pane:get_text_from_semantic_zone(zone)`

**라인**: 364-367

Semantic zone의 텍스트를 추출합니다.

```lua
local zones = pane:get_semantic_zones('Output')
if zones[1] then
  local text = pane:get_text_from_semantic_zone(zones[1])
  wezterm.log_info('Last output: ' .. text)
end
-- 반환: 문자열
```

**매개변수**:
- `zone`: semantic zone 테이블

### `pane:get_text_from_region(start_x, start_y, end_x, end_y)`

**라인**: 369-379

지정한 영역의 텍스트를 추출합니다.

```lua
local text = pane:get_text_from_region(0, 10, 80, 15)
-- 10-15줄, 0-80열 영역의 텍스트
-- 반환: 문자열
```

**매개변수**:
- `start_x`, `start_y`: 시작 좌표
- `end_x`, `end_y`: 끝 좌표

---

## Pane 조작 메서드

### `pane:window()`

**라인**: 126-131

Pane이 속한 window 객체를 반환합니다.

```lua
local window = pane:window()
if window then
  window:set_config_overrides({ font_size = 14 })
end
-- 반환: MuxWindow 객체 또는 nil
```

### `pane:tab()`

**라인**: 132-137

Pane이 속한 tab 객체를 반환합니다.

```lua
local tab = pane:tab()
if tab then
  wezterm.log_info('Tab ID: ' .. tab:tab_id())
end
-- 반환: MuxTab 객체 또는 nil
```

### `pane:split(args)` (async)

**라인**: 96-98

Pane을 분할하여 새 pane을 생성합니다.

```lua
-- 우측에 분할
pane:split {
  direction = 'Right',
  size = 0.5,  -- 50%
}

-- 하단에 분할
pane:split {
  direction = 'Bottom',
  size = 20,   -- 20 cells
  args = { '/bin/bash' },
  cwd = '/tmp',
}

-- 반환: 새로운 MuxPane 객체
```

**매개변수** (테이블):
- `direction`: `'Right'`, `'Left'`, `'Top'`, `'Bottom'`
- `size`: 0-1 사이 (비율) 또는 1 이상 (셀 수). 기본값: 0.5
- `args`: 실행할 명령어 배열 (선택)
- `cwd`: 작업 디렉토리 (선택)
- `domain`: domain 이름 (선택)
- `top_level`: 최상위 분할 여부 (선택, 기본: false)

### `pane:activate()`

**라인**: 407-429

이 pane을 활성화합니다.

```lua
pane:activate()
```

### `pane:move_to_new_tab()` (async)

**라인**: 381-392

Pane을 새 탭으로 이동합니다.

```lua
local new_tab, new_window = pane:move_to_new_tab()
wezterm.log_info('Moved to tab: ' .. new_tab:tab_id())
-- 반환: (MuxTab, MuxWindow)
```

### `pane:move_to_new_window([workspace])` (async)

**라인**: 394-405

Pane을 새 창으로 이동합니다.

```lua
local new_tab, new_window = pane:move_to_new_window()

-- 특정 workspace로 이동
local new_tab, new_window = pane:move_to_new_window('workspace-name')

-- 반환: (MuxTab, MuxWindow)
```

**매개변수**:
- `workspace` (선택): workspace 이름

---

## 반환 객체 타입

### Url 객체

`get_current_working_dir()`에서 반환:

```lua
{
  url = "file:///home/user/project",
  file_path = "/home/user/project",
  ...
}
```

### Dimensions 객체

`get_dimensions()`에서 반환:

```lua
{
  cols = 80,                -- 가로 크기 (문자)
  viewport_rows = 24,       -- 보이는 세로 크기
  physical_top = 0,         -- 스크롤백 기준 시작 위치
  scrollback_rows = 1000,   -- 스크롤백 크기
  pixel_width = 800,        -- 픽셀 너비
  pixel_height = 600,       -- 픽셀 높이
}
```

### Cursor Position 객체

`get_cursor_position()`에서 반환:

```lua
{
  x = 10,           -- X 좌표
  y = 5,            -- Y 좌표
  shape = "Block",  -- 커서 모양
  visibility = "Visible",
}
```

### Process Info 객체

`get_foreground_process_info()`에서 반환:

```lua
{
  pid = 1234,
  name = "vim",
  executable = "/usr/bin/vim",
  cwd = "/home/user/project",
  argv = { "vim", "file.txt" },
  ...
}
```

### Semantic Zone 객체

```lua
{
  semantic_type = "Output",  -- "Output", "Prompt", "Input"
  start_x = 0,
  start_y = 10,
  end_x = 50,
  end_y = 15,
}
```

---

## 사용 예시

### 예시 1: Status Bar에 현재 디렉토리 표시

```lua
local wezterm = require 'wezterm'

wezterm.on('update-status', function(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local cwd = ''
  if cwd_uri then
    cwd = cwd_uri.file_path or cwd_uri
  end

  window:set_right_status(cwd)
end)
```

### 예시 2: 프로세스 이름으로 탭 타이틀 설정

```lua
wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local process = pane.foreground_process_name

  if process then
    -- basename 추출
    local basename = process:match('([^/\\]+)$')
    return basename
  end

  return tab.tab_index + 1
end)
```

### 예시 3: 마지막 명령 출력 캡처

```lua
local wezterm = require 'wezterm'

wezterm.on('capture-last-output', function(window, pane)
  local zones = pane:get_semantic_zones('Output')

  if zones and #zones > 0 then
    -- 마지막 출력 zone
    local last_zone = zones[#zones]
    local text = pane:get_text_from_semantic_zone(last_zone)

    wezterm.log_info('Last output:\n' .. text)

    -- 클립보드에 복사
    window:copy_to_clipboard(text)
  end
end)

return {
  keys = {
    {
      key = 'Y',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.EmitEvent 'capture-last-output',
    },
  },
}
```

### 예시 4: SSH 연결 지연 표시

```lua
wezterm.on('update-status', function(window, pane)
  local metadata = pane:get_metadata()

  if metadata.since_last_response_ms then
    local lag = metadata.since_last_response_ms
    if lag > 100 then
      window:set_right_status(wezterm.format {
        { Foreground = { Color = 'orange' } },
        { Text = string.format('⏱ %dms', lag) },
      })
    end
  end
end)
```

### 예시 5: Alt Screen 감지

```lua
wezterm.on('update-status', function(window, pane)
  if pane:is_alt_screen_active() then
    -- vim, less 등이 실행 중
    window:set_right_status('📝')
  else
    window:set_right_status('')
  end
end)
```

### 예시 6: 새 출력 알림

```lua
wezterm.on('format-tab-title', function(tab)
  local title = tab.active_pane.title

  if tab.active_pane.has_unseen_output and not tab.is_active then
    return '🔔 ' .. title
  end

  return title
end)
```

### 예시 7: 스마트 분할 (현재 디렉토리 유지)

```lua
local wezterm = require 'wezterm'

return {
  keys = {
    {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action_callback(function(window, pane)
        local cwd_uri = pane:get_current_working_dir()
        local cwd = nil

        if cwd_uri then
          cwd = cwd_uri.file_path
        end

        pane:split {
          direction = 'Right',
          cwd = cwd,
        }
      end),
    },
  },
}
```

### 예시 8: 영역 텍스트 추출

```lua
wezterm.on('extract-region', function(window, pane)
  -- 10-20줄의 텍스트 추출
  local text = pane:get_text_from_region(0, 10, 80, 20)

  -- 파일로 저장
  local file = io.open('/tmp/extracted.txt', 'w')
  file:write(text)
  file:close()

  wezterm.log_info('Extracted to /tmp/extracted.txt')
end)
```

---

## 주의사항

1. **비동기 메서드**: `split`, `move_to_new_tab`, `move_to_new_window`는 비동기 메서드입니다. `action_callback` 내에서 사용하세요.

2. **Shell Integration**: Semantic zone 관련 기능은 shell integration 설정이 필요합니다.

3. **캐싱**: 일부 메서드 (`get_foreground_process_name`, `get_current_working_dir`)는 캐싱을 사용합니다. 최신 정보가 아닐 수 있습니다.

4. **Nil 반환**: 많은 메서드가 정보를 가져올 수 없을 때 `nil`을 반환합니다. 항상 `nil` 체크를 하세요.

5. **좌표 시스템**:
   - X 좌표: 0부터 시작 (왼쪽이 0)
   - Y 좌표: StableRowIndex (스크롤백 포함한 절대 행 번호)

---

## 관련 문서

- [PaneInformation](https://wezfurlong.org/wezterm/config/lua/PaneInformation.html)
- [Shell Integration](https://wezfurlong.org/wezterm/shell-integration.html)
- [User Vars](https://wezfurlong.org/wezterm/config/lua/pane/get_user_vars.html)

---

작성일: 2026-01-12
WezTerm 버전: main branch (6e02c91)
