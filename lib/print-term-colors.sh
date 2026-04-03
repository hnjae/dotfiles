#!/usr/bin/env bash

LABELS_NORMAL=("Black" "Red" "Green" "Yellow" "Blue" "Magenta" "Cyan" "White")
LABELS_BRIGHT=("Bright Black" "Bright Red" "Bright Green" "Bright Yellow" "Bright Blue" "Bright Magenta" "Bright Cyan" "Bright White")

# 기본 전경색/배경색
echo "=== Default FG/BG ==="
printf "  Default FG: \e[39m████\e[0m\n"
printf "  Default BG: \e[49m    \e[0m (transparent)\n"
echo ""

# ANSI 0-7
echo "=== ANSI 0-7: Normal Colors ==="
for ((i = 0; i < 8; i++)); do
    printf "  %2d %-10s \e[48;5;%dm      \e[0m\n" "$i" "${LABELS_NORMAL[$i]}" "$i"
done
echo ""

# ANSI 8-15
echo "=== ANSI 8-15: Bright Colors ==="
for ((i = 8; i < 16; i++)); do
    printf "  %2d %-14s \e[48;5;%dm      \e[0m\n" "$i" "${LABELS_BRIGHT[$((i - 8))]}" "$i"
done
echo ""

# ANSI 16-231: 6x6x6 Color Cube
echo "=== ANSI 16-231: 6x6x6 Color Cube ==="
for ((i = 16; i < 232; i++)); do
    printf "\e[48;5;%d;38;5;%dm %3d \e[0m" "$i" "$((i < 124 ? 255 : 0))" "$i"
    if (((i - 15) % 12 == 0)); then
        echo
    fi
done
echo ""

# ANSI 232-255: Grayscale
echo "=== ANSI 232-255: Grayscale ==="
for ((i = 232; i < 256; i++)); do
    printf "\e[48;5;%d;38;5;%dm %3d \e[0m" "$i" "$((i < 244 ? 255 : 0))" "$i"
done
echo ""
