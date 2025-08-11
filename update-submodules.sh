#!/usr/bin/env bash

# git submodule sync --quiet --recursive  # URL만 업데이트
# git submodule update --init --recursive # 실제 코드 가져오기

# git submodule foreach git fetch

main() {
  local modules=(
    '.lib/dotbot'
    '@xdg-data-home/zimfw'
  )

  for module in "${modules[@]}"; do
    local latest_tag

    git -C "$module" fetch --tags
    latest_tag="$(git -C "$module" describe --tags --abbrev=0)"
    git -C "$module" checkout -q "$latest_tag" &&
      echo "$module checked-out to $latest_tag" >/dev/stderr
  done
}

main
