#!/usr/bin/sh

# Wayland & X11
# Fallback profile for sddm if $SHELL's profile does not exists

# THIS FILE SHOULD BE SOURCED BY $SHELL'S PROFILE. (to be used)

# Loads Before .xprofile
# XDG_* 로 시작하는 변수는 이걸 소스하기 전에 선언되었는듯.

# ime=fcitx5
# export QT_IM_MODULE="$ime"
# export GTK_IM_MODULE="$ime"
# export XMODIFIERS="@im=$ime"
# export SDL_IM_MODULE="$ime"
# export GLFW_IM_MODULE=ibus

export EDITOR="nvim"
export PAGER="less"
export BROWSER="firefox"
export TERMINAL="termite"
# export MOZ_WEBRENDER=1
# export LESS="-rniwMS --use-color -z-4"

# -r : (--rwa-control-chars)
# -R : --RAW-CONTROL-CHARS : it works
# -i: (--ignore-case ())
# -n: --line-numbers | prompt line number under
# -w: hilite-unread
# -m: --long-prompt
# -u: unserline-special
# -M: causes less to promp enve more verbosely than more (어캐 되는지 잘 모르겠음)
# -S: no wrapping
# -z-4: scrolling window size 조정
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
# export LESS='-g -i -M -R -S -w -X -z-4'
# export LESS='-g -M -S -X -z-4'
# -g: highlignt only the particular string which was found by the last search command


# if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
#     unset MOZ_X11_EGL
#     export MOZ_ENABLE_WAYLAND=1
#     export GDK_BACKEND="wayland"
#     export QT_QPA_PLATFORM="wayland"
#     export CLUTTER_BACKEND="wayland"
#     export SDL_VIDEODRIVER="wayland"
#     export WINIT_UNIX_BACKEND="wayland"
#     export BEMENU_BACKEND="wayland"
#
#     if [ \
#             "$XDG_CURRENT_DESKTOP" = "KDE" \
#             -o "$DESKTOP_SESSION" = "plasmawayland" \
#             ]; then
#             echo ""
#             unset QT_QPA_PLATFORMTHEME
#             unset GTK_USE_PORTAL
#     else
#             # Consistent file dialog
#             export QT_QPA_PLATFORMTHEME="gnome"
#             export GTK_USE_PORTAL=1
#     fi
# fi
#
# export CALIBRE_USE_DARK_PALETTE=1
# export GTKM_INSERT_EMOJI=1
# export CM_LAUNCHER="rofi"
#
# # export VK_ICD_FILENAMES="/usr/share/vulkan/icd.d/amd_pro_icd64.json:/usr/share/vulkan/icd.d/amd_pro_icd32.json"
# # export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
#
# [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] \
#     && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
