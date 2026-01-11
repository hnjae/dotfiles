# WezTerm Lua API 참조 가이드

## 목차

1. [연결 타입 확인 (SSH/Serial/Local)](#연결-타입-확인)
2. [Tab Bar 기본 색상](#tab-bar-기본-색상)
3. [커스텀 Color Scheme](#커스텀-color-scheme)
4. [Lua에서 색상 값 읽기](#lua에서-색상-값-읽기)

---

## 연결 타입 확인

### `pane:get_domain_name()` API

pane이 속한 domain의 이름을 반환합니다.

```lua
local domain = pane:get_domain_name()
```

**구현 위치**: `lua-api-crates/mux/src/pane.rs:277-291`

### Domain 이름 규칙

#### 1. 직접 연결 (임시 domain)

```bash
# SSH 직접 연결
wezterm ssh user@192.168.0.2
# → Domain name: "SSH to user@192.168.0.2"
# 구현: wezterm-gui/src/main.rs:146

# Serial 직접 연결
wezterm serial /dev/ttyUSB0
# → Domain name: "Serial Port /dev/ttyUSB0"
# 구현: wezterm-gui/src/main.rs:206
```

#### 2. 설정 파일에서 정의한 domain

```lua
-- ~/.wezterm.lua
config.ssh_domains = {
  {
    name = 'my-server',  -- 이 이름이 domain_name으로 반환됨
    remote_address = '192.168.1.100',
    username = 'user',
  },
}

config.serial_ports = {
  {
    name = 'Sensor 1',  -- 이 이름이 domain_name으로 반환됨
    port = '/dev/tty.usbserial-10',
    baud = 115200,
  },
}
```

**접속 방법**:
```bash
wezterm connect my-server   # SSH domain
wezterm connect 'Sensor 1'  # Serial domain
```

#### 3. 로컬 터미널

```lua
-- Domain name: "local"
```

### 연결 타입 구분 예시

```lua
local wezterm = require 'wezterm'

wezterm.on('format-tab-title', function(tab)
  local domain = tab.active_pane.domain_name
  local icon = ''

  if domain:match('^SSH to ') then
    icon = '🌐 '  -- wezterm ssh로 직접 연결
  elseif domain:match('^Serial Port ') then
    icon = '📟 '  -- wezterm serial로 직접 연결
  elseif domain == 'local' then
    icon = '💻 '  -- 로컬
  else
    -- 설정 파일에서 정의한 domain
    -- 타입을 직접 확인할 수 없으므로 별도 관리 필요
    icon = '🔗 '
  end

  return icon .. tab.active_pane.title
end)
```

### 설정 파일에서 domain 타입 관리

Lua API에는 domain 타입을 직접 확인하는 방법이 없으므로, 직접 추적:

```lua
local config = {}

-- domain 타입 매핑
local domain_types = {
  ['my-server'] = 'ssh',
  ['work-dev'] = 'ssh',
  ['Sensor 1'] = 'serial',
  ['Sensor 2'] = 'serial',
}

config.ssh_domains = {
  { name = 'my-server', remote_address = '192.168.1.100' },
  { name = 'work-dev', remote_address = 'dev.work.com' },
}

config.serial_ports = {
  { name = 'Sensor 1', port = '/dev/tty.usbserial-10', baud = 115200 },
  { name = 'Sensor 2', port = '/dev/tty.usbserial-11', baud = 115200 },
}

wezterm.on('format-tab-title', function(tab)
  local domain = tab.active_pane.domain_name
  local dtype = domain_types[domain]

  if dtype == 'ssh' then
    return '🌐 ' .. tab.active_pane.title
  elseif dtype == 'serial' then
    return '📟 ' .. tab.active_pane.title
  else
    return tab.active_pane.title
  end
end)

return config
```

---

## Tab Bar 기본 색상

**구현 위치**: `config/src/color.rs:482-515`

### 기본값

```lua
config.colors = {
  tab_bar = {
    -- 탭 바 배경색
    background = '#333333',

    -- 활성 탭
    active_tab = {
      bg_color = '#000000',
      fg_color = '#c0c0c0',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    -- 비활성 탭
    inactive_tab = {
      bg_color = '#333333',
      fg_color = '#808080',
    },

    -- 비활성 탭 (마우스 호버)
    inactive_tab_hover = {
      bg_color = '#1f1f1f',
      fg_color = '#909090',
      italic = true,
    },

    -- 새 탭 버튼 (inactive_tab과 동일)
    new_tab = {
      bg_color = '#333333',
      fg_color = '#808080',
    },

    -- 새 탭 버튼 (마우스 호버)
    new_tab_hover = {
      bg_color = '#1f1f1f',
      fg_color = '#909090',
      italic = true,
    },

    -- 비활성 탭 테두리
    inactive_tab_edge = '#575757',

    -- 비활성 탭 테두리 (마우스 호버)
    inactive_tab_edge_hover = '#363636',
  }
}
```

### 색상 코드 상세

| 항목 | 배경색 | 전경색 | 기타 |
|------|--------|--------|------|
| **background** | `#333333` | - | - |
| **active_tab** | `#000000` | `#c0c0c0` | - |
| **inactive_tab** | `#333333` | `#808080` | - |
| **inactive_tab_hover** | `#1f1f1f` | `#909090` | italic |
| **new_tab** | `#333333` | `#808080` | - |
| **new_tab_hover** | `#1f1f1f` | `#909090` | italic |
| **inactive_tab_edge** | `#575757` | - | - |
| **inactive_tab_edge_hover** | `#363636` | - | - |

---

## 커스텀 Color Scheme

### TOML 파일 형식

wezterm은 `~/.config/wezterm/colors/<name>.toml` 경로의 커스텀 color scheme을 지원합니다.

**참고**: `Palette` 구조체에 `tab_bar` 필드가 포함되어 있어 tab_bar 색상도 정의 가능합니다.
**구현 위치**: `config/src/color.rs:152`

### 예시: `~/.config/wezterm/colors/my-theme.toml`

```toml
[colors]
foreground = '#c0c0c0'
background = '#1a1a1a'

ansi = [
    '#000000',
    '#cd0000',
    '#00cd00',
    '#cdcd00',
    '#0000ee',
    '#cd00cd',
    '#00cdcd',
    '#e5e5e5',
]

brights = [
    '#7f7f7f',
    '#ff0000',
    '#00ff00',
    '#ffff00',
    '#5c5cff',
    '#ff00ff',
    '#00ffff',
    '#ffffff',
]

# tab_bar 색상 정의
[colors.tab_bar]
background = '#1a1a1a'

[colors.tab_bar.active_tab]
bg_color = '#2b2b2b'
fg_color = '#ffffff'
intensity = 'Bold'
italic = false

[colors.tab_bar.inactive_tab]
bg_color = '#1a1a1a'
fg_color = '#808080'

[colors.tab_bar.inactive_tab_hover]
bg_color = '#3a3a3a'
fg_color = '#909090'
italic = true

[colors.tab_bar.new_tab]
bg_color = '#1a1a1a'
fg_color = '#808080'

[colors.tab_bar.new_tab_hover]
bg_color = '#3a3a3a'
fg_color = '#909090'

inactive_tab_edge = '#444444'
inactive_tab_edge_hover = '#555555'

[metadata]
name = 'My Custom Theme'
author = 'Your Name'
origin_url = 'https://example.com'
```

### 사용법

```lua
-- ~/.wezterm.lua
local config = {}

config.color_scheme = 'My Custom Theme'
-- 또는 파일명 (확장자 제외)
-- config.color_scheme = 'my-theme'

return config
```

### Color Scheme 자동 로드 경로

**구현 위치**: `config/src/config.rs:1410-1424`

- Linux/macOS: `~/.config/wezterm/colors/`
- macOS: `~/.wezterm/colors/`
- Windows: 실행 파일 디렉토리와 설정 디렉토리의 `colors/` 폴더

파일 이름에서 `.toml` 확장자를 제외한 부분이 scheme 이름이 됩니다.

---

## Lua에서 색상 값 읽기

### 방법 1: `window:effective_config()` 사용 (권장)

현재 적용된 최종 색상 값을 확인:

```lua
local wezterm = require 'wezterm'

wezterm.on('update-status', function(window, pane)
  local config = window:effective_config()

  -- 현재 적용된 색상 직접 확인
  local palette = config.resolved_palette

  wezterm.log_info('Background: ' .. tostring(palette.background))
  wezterm.log_info('Foreground: ' .. tostring(palette.foreground))

  -- tab_bar 색상도 확인 가능
  if palette.tab_bar then
    local tab_bar = palette.tab_bar
    if tab_bar.active_tab then
      wezterm.log_info('Active tab bg: ' .. tostring(tab_bar.active_tab.bg_color))
      wezterm.log_info('Active tab fg: ' .. tostring(tab_bar.active_tab.fg_color))
    end
    if tab_bar.background then
      wezterm.log_info('Tab bar bg: ' .. tostring(tab_bar.background))
    end
  end
end)
```

**참고**: `resolved_palette`는 color scheme과 `config.colors` 오버라이드가 모두 적용된 최종 팔레트입니다.

### 방법 2: `wezterm.color.load_scheme()` 사용

TOML 파일을 직접 로드:

```lua
local wezterm = require 'wezterm'

-- 커스텀 스킴 파일 직접 로드
local colors, metadata = wezterm.color.load_scheme(
  wezterm.config_dir .. '/colors/foo.toml'
)

wezterm.log_info('Background: ' .. colors.background)
wezterm.log_info('Foreground: ' .. colors.foreground)
wezterm.log_info('Scheme name: ' .. metadata.name)

-- tab_bar 색상 확인
if colors.tab_bar then
  if colors.tab_bar.active_tab then
    wezterm.log_info('Active tab bg: ' .. colors.tab_bar.active_tab.bg_color)
  end
end
```

**API 위치**: `lua-api-crates/color-funcs/src/lib.rs:130-138`

### 방법 3: `effective_config()`의 `color_schemes` 테이블

커스텀 스킴도 설정 로드 시 `color_schemes`에 추가됩니다:

```lua
local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'foo'

wezterm.on('window-config-reloaded', function(window, pane)
  local effective = window:effective_config()

  -- 현재 설정된 스킴 이름
  local scheme_name = effective.color_scheme  -- 'foo'

  -- 해당 스킴의 정의 가져오기
  local scheme = effective.color_schemes[scheme_name]

  if scheme then
    wezterm.log_info('Scheme background: ' .. tostring(scheme.background))
    if scheme.tab_bar then
      wezterm.log_info('Tab bar bg: ' .. tostring(scheme.tab_bar.background))
    end
  end
end)

return config
```

### 방법 4: 빌트인 스킴 목록 조회

```lua
local wezterm = require 'wezterm'

-- 모든 빌트인 스킴 가져오기
local builtin_schemes = wezterm.color.get_builtin_schemes()

-- 특정 스킴 수정
local my_scheme = builtin_schemes['Gruvbox Light']
my_scheme.background = '#f0f0f0'
if my_scheme.tab_bar then
  my_scheme.tab_bar.active_tab.bg_color = '#e0e0e0'
end

return {
  color_schemes = {
    ['My Gruvbox'] = my_scheme,
  },
  color_scheme = 'My Gruvbox',
}
```

**API 위치**: `lua-api-crates/color-funcs/src/lib.rs:177-180`

### 예시: tab_bar 색상 기반으로 다른 색상 계산

```lua
local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'foo'

wezterm.on('update-status', function(window, pane)
  local effective = window:effective_config()
  local palette = effective.resolved_palette

  if palette.tab_bar and palette.tab_bar.active_tab then
    -- 현재 active tab 색상 가져오기
    local active_bg = wezterm.color.parse(palette.tab_bar.active_tab.bg_color)

    -- 색상 조작
    local h, s, l, a = active_bg:hsla()
    local lighter = active_bg:lighten(0.1)
    local darker = active_bg:darken(0.1)
    local saturated = active_bg:saturate(0.2)

    wezterm.log_info('Active tab lightness: ' .. tostring(l))
    wezterm.log_info('Lighter version: ' .. tostring(lighter))
    wezterm.log_info('Darker version: ' .. tostring(darker))
    wezterm.log_info('More saturated: ' .. tostring(saturated))
  end
end)

return config
```

### 색상 객체 메서드

`wezterm.color.parse()`로 생성한 색상 객체는 다양한 조작 메서드를 제공:

**구현 위치**: `lua-api-crates/color-funcs/src/lib.rs:48-106`

```lua
local color = wezterm.color.parse('#ff0000')

-- 색상 조작
color:lighten(0.1)        -- 밝게
color:darken(0.1)         -- 어둡게
color:saturate(0.1)       -- 채도 증가
color:desaturate(0.1)     -- 채도 감소
color:adjust_hue_fixed(30) -- 색조 조정

-- 색상 정보 추출
local h, s, l, a = color:hsla()  -- HSLA
local r, g, b, a = color:srgba_u8()  -- RGBA (0-255)
local r, g, b, a = color:linear_rgba()  -- Linear RGB
local l, a, b, alpha = color:laba()  -- LAB

-- 색상 관계
color:complement()        -- 보색
color:complement_ryb()    -- RYB 보색
local c1, c2 = color:triad()  -- 삼색 조화
local c1, c2, c3 = color:square()  -- 사색 조화

-- 색상 비교
color:contrast_ratio(other_color)  -- 명암비
color:delta_e(other_color)  -- 색 차이 (Delta E)
```

---

## 유용한 API 레퍼런스

### 색상 관련
- `wezterm.color.parse(spec)` - 색상 문자열 파싱
- `wezterm.color.get_builtin_schemes()` - 빌트인 color scheme 목록
- `wezterm.color.get_default_colors()` - 기본 색상 팔레트
- `wezterm.color.load_scheme(file)` - TOML 파일에서 로드
- `wezterm.color.save_scheme(colors, metadata, file)` - TOML로 저장

### Pane 관련
- `pane:get_domain_name()` - domain 이름
- `pane:get_title()` - pane 제목
- `pane:get_foreground_process_name()` - 실행 중인 프로세스
- `pane:get_current_working_dir()` - 현재 작업 디렉토리
- `pane:get_user_vars()` - 사용자 변수
- `pane:get_metadata()` - 메타데이터

### Window 관련
- `window:effective_config()` - 적용된 설정 (resolved_palette 포함)
- `window:get_config_overrides()` - 설정 오버라이드
- `window:set_config_overrides(overrides)` - 설정 오버라이드 설정

---

## 참고 자료

### 공식 문서
- [PaneInformation](https://wezfurlong.org/wezterm/config/lua/PaneInformation.html)
- [Colors & Appearance](https://wezfurlong.org/wezterm/config/appearance.html)
- [SSH Domains](https://wezfurlong.org/wezterm/multiplexing.html#ssh-domains)
- [Serial Ports](https://wezfurlong.org/wezterm/config/lua/config/serial_ports.html)

### 소스 코드 위치
- Pane Lua API: `lua-api-crates/mux/src/pane.rs`
- Color Lua API: `lua-api-crates/color-funcs/src/lib.rs`
- Color Config: `config/src/color.rs`
- Domain Implementation: `mux/src/domain.rs`, `mux/src/ssh.rs`
- SSH/Serial Commands: `wezterm-gui/src/main.rs`

---

작성일: 2026-01-12
WezTerm 버전: main branch (6e02c91)
