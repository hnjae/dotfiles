# WezTerm Inactive Pane Styling 가이드

**구현 위치**: `config/src/config.rs:591-621, 1883-1888`
**문서 위치**: `docs/config/appearance.md:411-447`

## 목차

1. [개요](#개요)
2. [기본 설정](#기본-설정)
3. [HSB Transform 상세](#hsb-transform-상세)
4. [설정 예시](#설정-예시)
5. [시각적 효과](#시각적-효과)
6. [실용적인 팁](#실용적인-팁)

---

## 개요

WezTerm은 비활성 pane을 자동으로 dim 처리하여 현재 활성화된 pane을 쉽게 구분할 수 있도록 합니다.

`inactive_pane_hsb` 설정을 통해 비활성 pane의 색상 변환을 제어할 수 있습니다.

---

## 기본 설정

### 기본값

```lua
config.inactive_pane_hsb = {
  saturation = 0.9,  -- 채도 90%
  brightness = 0.8,  -- 밝기 80%
}
```

**효과**: 비활성 pane이 약간 회색빛을 띠고(채도 10% 감소), 20% 어두워집니다.

### 구조

```lua
{
  hue = 1.0,         -- 색조 (선택, 기본값: 1.0)
  saturation = 0.9,  -- 채도 (필수)
  brightness = 0.8,  -- 밝기 (필수)
}
```

---

## HSB Transform 상세

### 동작 원리

1. RGB 색상을 HSV(HSB) 색상 공간으로 변환
2. 각 HSV 값에 설정된 배율을 곱함
3. 다시 RGB로 변환하여 화면에 표시

**소스 코드**: `config/src/color.rs:12-27`

```rust
pub struct HsbTransform {
    pub hue: f32,         // 기본값: 1.0
    pub saturation: f32,  // 기본값: 1.0
    pub brightness: f32,  // 기본값: 1.0
}
```

### Hue (색조)

**범위**: 0.0 이상
**기본값**: 1.0

색상환(color wheel)을 회전시킵니다.

```lua
-- 색조 변경 예시
config.inactive_pane_hsb = {
  hue = 1.0,         -- 변경 없음 (기본)
  saturation = 0.9,
  brightness = 0.8,
}

-- 약간 파란빛으로 회전
config.inactive_pane_hsb = {
  hue = 1.1,         -- 색조를 10% 회전
  saturation = 0.9,
  brightness = 0.8,
}

-- 보색으로 변환 (180도 회전)
config.inactive_pane_hsb = {
  hue = 1.5,         -- 약 180도 회전
  saturation = 0.9,
  brightness = 0.8,
}
```

**참고**: 색조 변경은 비활성 pane 구분에는 별로 유용하지 않으므로 보통 1.0으로 유지합니다.

### Saturation (채도)

**범위**: 0.0 이상
**기본값**: 1.0

색상의 선명도를 조절합니다.

```lua
-- 채도 조절 예시

-- 매우 선명 (변경 없음)
saturation = 1.0

-- 약간 회색빛 (기본 dim)
saturation = 0.9

-- 중간 정도 회색빛
saturation = 0.7

-- 많이 회색빛
saturation = 0.5

-- 완전 흑백
saturation = 0.0
```

**효과**:
- `1.0`: 원본 색상 유지
- `0.9`: 10% 채도 감소 (약간 회색빛)
- `0.5`: 50% 채도 감소 (상당히 회색빛)
- `0.0`: 완전 흑백
- `2.0`: 채도 2배 증가 (매우 선명, 비현실적)

### Brightness (밝기)

**범위**: 0.0 이상
**기본값**: 1.0

색상의 밝기를 조절합니다.

```lua
-- 밝기 조절 예시

-- 매우 밝음 (변경 없음)
brightness = 1.0

-- 약간 어두움 (기본 dim)
brightness = 0.8

-- 중간 정도 어두움
brightness = 0.6

-- 많이 어두움
brightness = 0.4

-- 거의 검정
brightness = 0.1

-- 완전 검정
brightness = 0.0
```

**효과**:
- `1.0`: 원본 밝기 유지
- `0.8`: 20% 어두워짐 (기본)
- `0.5`: 50% 어두워짐
- `0.0`: 완전 검정
- `2.0`: 밝기 2배 (매우 밝음, 비현실적)

---

## 설정 예시

### 예시 1: 기본 설정 (권장)

```lua
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}
```

**효과**: 미묘하지만 명확한 구분. 대부분의 사용자에게 적합.

### 예시 2: 매우 미묘한 dim

```lua
config.inactive_pane_hsb = {
  saturation = 0.98,
  brightness = 0.95,
}
```

**효과**: 거의 구분이 안 될 정도로 약한 dim. 여러 pane을 동시에 보면서 작업할 때 유용.

### 예시 3: 강한 dim

```lua
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
}
```

**효과**: 매우 명확한 구분. 활성 pane에만 집중하고 싶을 때 유용.

### 예시 4: 극도로 강한 dim

```lua
config.inactive_pane_hsb = {
  saturation = 0.5,
  brightness = 0.4,
}
```

**효과**: 비활성 pane이 거의 보이지 않을 정도. 방해받지 않고 작업할 때.

### 예시 5: dim 완전 비활성화

```lua
config.inactive_pane_hsb = {
  saturation = 1.0,
  brightness = 1.0,
}
```

**효과**: 모든 pane이 동일한 밝기. 구분이 필요 없을 때.

### 예시 6: 흑백 효과

```lua
config.inactive_pane_hsb = {
  saturation = 0.0,  -- 완전 흑백
  brightness = 0.8,
}
```

**효과**: 비활성 pane이 흑백으로 표시됨. 매우 독특한 시각적 효과.

### 예시 7: 밝기만 조절

```lua
config.inactive_pane_hsb = {
  saturation = 1.0,   -- 채도 유지
  brightness = 0.7,   -- 밝기만 감소
}
```

**효과**: 색상은 유지하면서 어둡게만 함.

### 예시 8: 채도만 조절

```lua
config.inactive_pane_hsb = {
  saturation = 0.6,   -- 채도만 감소
  brightness = 1.0,   -- 밝기 유지
}
```

**효과**: 밝기는 유지하면서 회색빛만 추가.

### 예시 9: 색조 변경 (실험적)

```lua
config.inactive_pane_hsb = {
  hue = 1.2,          -- 파란빛으로 회전
  saturation = 0.8,
  brightness = 0.7,
}
```

**효과**: 비활성 pane이 약간 파란 톤으로 변경됨.

### 예시 10: 다크 테마용

```lua
-- 다크 배경에서 비활성 pane을 더 어둡게
config.inactive_pane_hsb = {
  saturation = 0.85,
  brightness = 0.7,
}
```

### 예시 11: 라이트 테마용

```lua
-- 라이트 배경에서는 약하게
config.inactive_pane_hsb = {
  saturation = 0.95,
  brightness = 0.9,
}
```

---

## 시각적 효과

### 밝기(Brightness) 비교

| 설정 | 시각적 효과 | 용도 |
|------|-------------|------|
| `brightness = 1.0` | 변경 없음 | dim 비활성화 |
| `brightness = 0.95` | 매우 미묘 | 약한 구분 |
| `brightness = 0.8` | 적당함 (기본) | 일반적인 사용 |
| `brightness = 0.6` | 어두움 | 강한 구분 |
| `brightness = 0.4` | 매우 어두움 | 집중 모드 |
| `brightness = 0.0` | 완전 검정 | 권장하지 않음 |

### 채도(Saturation) 비교

| 설정 | 시각적 효과 | 용도 |
|------|-------------|------|
| `saturation = 1.0` | 변경 없음 | 색상 유지 |
| `saturation = 0.9` | 약간 회색빛 (기본) | 일반적인 사용 |
| `saturation = 0.7` | 회색빛 | 차분한 효과 |
| `saturation = 0.5` | 많이 회색빛 | 강한 dim |
| `saturation = 0.0` | 완전 흑백 | 특수 효과 |

---

## 실용적인 팁

### 1. 테마별 추천 설정

```lua
local wezterm = require 'wezterm'
local config = {}

-- 다크 테마
if wezterm.gui.get_appearance():find('Dark') then
  config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.7,
  }
-- 라이트 테마
else
  config.inactive_pane_hsb = {
    saturation = 0.95,
    brightness = 0.9,
  }
end

return config
```

### 2. 작업 모드별 설정

```lua
local config = {}

-- 일반 작업: 적당한 dim
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- 집중 모드용 키 바인딩
config.keys = {
  {
    key = 'f',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- 강한 dim으로 전환
      window:set_config_overrides({
        inactive_pane_hsb = {
          saturation = 0.5,
          brightness = 0.4,
        }
      })
    end),
  },
  {
    key = 'n',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      -- 일반 모드로 복귀
      window:set_config_overrides({
        inactive_pane_hsb = {
          saturation = 0.9,
          brightness = 0.8,
        }
      })
    end),
  },
}

return config
```

### 3. 색상 스킴에 따라 자동 조절

```lua
local config = {}

config.color_scheme = 'Gruvbox Dark'

-- 어두운 색상 스킴: 더 강한 dim
local dark_schemes = {
  ['Gruvbox Dark'] = true,
  ['Tokyo Night'] = true,
  ['Dracula'] = true,
}

if dark_schemes[config.color_scheme] then
  config.inactive_pane_hsb = {
    saturation = 0.85,
    brightness = 0.7,
  }
else
  config.inactive_pane_hsb = {
    saturation = 0.95,
    brightness = 0.9,
  }
end

return config
```

### 4. pane 개수에 따라 조절

```lua
local wezterm = require 'wezterm'

wezterm.on('update-status', function(window, pane)
  local tab = pane:tab()
  if tab then
    local panes = tab:panes()
    local pane_count = #panes

    -- pane이 많을수록 강하게 dim
    if pane_count >= 4 then
      window:set_config_overrides({
        inactive_pane_hsb = {
          saturation = 0.7,
          brightness = 0.6,
        }
      })
    elseif pane_count >= 2 then
      window:set_config_overrides({
        inactive_pane_hsb = {
          saturation = 0.9,
          brightness = 0.8,
        }
      })
    else
      -- 단일 pane일 때는 dim 불필요
      window:set_config_overrides({
        inactive_pane_hsb = {
          saturation = 1.0,
          brightness = 1.0,
        }
      })
    end
  end
end)
```

### 5. 시간대별 자동 조절

```lua
local wezterm = require 'wezterm'
local config = {}

local function get_hour()
  return tonumber(os.date('%H'))
end

local hour = get_hour()

-- 밤 시간(22-6시): 강한 dim
if hour >= 22 or hour < 6 then
  config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  }
-- 낮 시간: 보통 dim
else
  config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
  }
end

return config
```

---

## 디버깅 및 테스트

### 실시간 테스트

```lua
-- 키 바인딩으로 실시간 테스트
local config = {}

config.keys = {
  -- 밝기 증가
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      local hsb = overrides.inactive_pane_hsb or { saturation = 0.9, brightness = 0.8 }
      hsb.brightness = math.min(1.0, hsb.brightness + 0.05)
      overrides.inactive_pane_hsb = hsb
      window:set_config_overrides(overrides)
      wezterm.log_info('Brightness: ' .. hsb.brightness)
    end),
  },
  -- 밝기 감소
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      local hsb = overrides.inactive_pane_hsb or { saturation = 0.9, brightness = 0.8 }
      hsb.brightness = math.max(0.0, hsb.brightness - 0.05)
      overrides.inactive_pane_hsb = hsb
      window:set_config_overrides(overrides)
      wezterm.log_info('Brightness: ' .. hsb.brightness)
    end),
  },
  -- 채도 증가
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      local hsb = overrides.inactive_pane_hsb or { saturation = 0.9, brightness = 0.8 }
      hsb.saturation = math.min(1.0, hsb.saturation + 0.05)
      overrides.inactive_pane_hsb = hsb
      window:set_config_overrides(overrides)
      wezterm.log_info('Saturation: ' .. hsb.saturation)
    end),
  },
  -- 채도 감소
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      local hsb = overrides.inactive_pane_hsb or { saturation = 0.9, brightness = 0.8 }
      hsb.saturation = math.max(0.0, hsb.saturation - 0.05)
      overrides.inactive_pane_hsb = hsb
      window:set_config_overrides(overrides)
      wezterm.log_info('Saturation: ' .. hsb.saturation)
    end),
  },
}

return config
```

---

## 주의사항

1. **값의 범위**: 모든 값은 0.0 이상이어야 합니다. 음수는 사용할 수 없습니다.

2. **성능**: 이 설정은 성능에 거의 영향을 주지 않습니다. 색상 변환은 GPU에서 효율적으로 처리됩니다.

3. **색상 정확도**: 매우 높은 값 (예: 2.0 이상)을 사용하면 색상이 비현실적으로 변할 수 있습니다.

4. **접근성**: 시각 장애가 있는 사용자는 더 강한 dim 설정이 도움이 될 수 있습니다.

5. **배경 이미지**: 배경 이미지를 사용하는 경우, dim 효과가 덜 명확할 수 있습니다.

---

## 관련 설정

### window_background_image_hsb

배경 이미지에도 동일한 HSB 변환을 적용할 수 있습니다:

```lua
config.window_background_image = '/path/to/wallpaper.jpg'

config.window_background_image_hsb = {
  brightness = 0.3,  -- 배경을 어둡게
  hue = 1.0,
  saturation = 1.0,
}
```

### foreground_text_hsb

전경 텍스트에도 HSB 변환 적용 가능:

```lua
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 1.0,
}
```

---

## 공식 문서 참조

- [Styling Inactive Panes](https://wezfurlong.org/wezterm/config/appearance.html#styling-inactive-panes)
- [Colors & Appearance](https://wezfurlong.org/wezterm/config/appearance.html)

---

작성일: 2026-01-12
WezTerm 버전: main branch (6e02c91)
