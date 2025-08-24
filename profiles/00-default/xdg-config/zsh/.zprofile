# NOTE:
# Will be sourced after .zshenv and before .zshrc
# Will NOT be sourced if the shell is not a login shell

# HACK: <NixOS 25.05>
# Login shell (e.g. ssh 로그인) 의 경우, .zshenv 의 no_global_rcs 가 무시되고, `/etc/zshrc` 를 source 함. 왜 일까..
# NixOS 의 경우 아래의 flag 로 /etc/zshrc 를 이미 source 했다고 치고 무시할 수 있음. (nixpkgs 의 zsh 모듈이 해당 플래그를 사용하는 if 문을 가지고 있음)

NOSYSZSHRC=1
