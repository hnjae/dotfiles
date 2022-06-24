#!/usr/bin/env zsh

# alias x='cd $(fzf)'
alias fzf='fzf --preview "bat --color=always --line-range :500 {}"'
# alias cat="bat -pp"
# alias od="hexyl"

if [[ "$OSTYPE" = darwin* ]]; then
    alias ripIso="hdiutil makehybrid -iso -joliet"
    alias nfd2nfc="convmv -r -f utf8 -t utf8 --nfc --notest ."
elif [[ "$OSTYPE" = linux* ]]; then
    alias xkb="setxkbmap -model pc104 -layout us -option ctrl:nocaps,altwin:swap_alt_win"
    alias du2="ls --escape --group-directories-first | xargs btrfs fi du -s -h"
    alias du1="ls --escape --group-directories-first | xargs du -h --max-depth=0"
    alias du0="fd . --type f | wc -l"
fi

# test locate && alias ll="locate"
alias lir='ssh 192.168.1.200 locate -d /var/lib/plocate/media.db -i -r'
alias li='ssh 192.168.1.200 locate -d /var/lib/plocate/media.db -i '
alias lou='locate-uniq.py all'
alias loud='locate-uniq.py dir'
alias louf='locate-uniq.py file'
# alias ll='ssh 192.168.1.200 locate -d /var/lib/plocate/media.db -i --limit 5000'

alias flacEncDefault="flac --verify --exhaustive-model-search --replay-gain --best"
alias img2webp="cwebp -lossless -z 9 -mt -progress -v -metadata all"
alias img2webp_help='echo "img2webp input_file -o output_file.webp"'
alias f644="find . -type f -print0 | xargs -0 chmod 644"
alias d755="find . -type d -print0 | xargs -0 chmod 755"
alias jhj="jhead -exonly -dt -nf%y%m%d-%H%M%S"

# rar
# Uses: $ rarmax backup.rar originDIR
# Uses: $ rar <command> [switchs] <archive> <files..>
# Use Command "c" to add archive comment
# Use Swtich "p[password]" to set password
# alias rarhelp="echo "rarcommand options \<archive\> \<files..\>""
alias rarhelp="echo 'rarArchive backup.rar dir'"
# alias rarArchive="rar a -r -htb -ma5 -rr10 -m5 -s- -msflac;mp3;rar;png;mp4;mkv;jpg;heic -t"
alias rarArchive="rar a -r -htb -ma5 -rr10 -m5 -s- -t"
#   r             Recurse subdirectories
#   ht[b|c]       Select hash type [BLAKE2,CRC32] for file checksum
#   ma[4|5]       Specify a version of archiving format
#   m<0..5>       Set compression level (0-store...3-default...5-maximal)
#   ms[ext;ext]   Specify file types to store
#   rr[N]         Add data recovery record
#   s-            Disable solid archiving

# ETC
# -dt delte thumbnails from the exif header

# 7z
alias 7zhelp='echo "7z archive.7z directory"'
alias 7zmax="7z a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=64m -ms=on -mta -mtc"
alias 7zppmd="7z a -t7z -m0ppmd -mx=9 -mmem=64m -o=32 -mta -mtc"
alias 7zmin="7z a -t7z -m0=lzma2 -mx=1 -mfb=32 -md=64k -ms=off -mta -mtc"
alias 7zstore="7z a -t7z -m0=copy -mta -mtc"

# zip
alias zipnone="zip -r0oT"	#zipnone $archive $file's'
alias 7zzip="7z a -tzip -mx=0" #7zzip $archive
alias 7zzipdeflate="7z a -tzip -mx=9 -m0=deflate64"

# alias youtubeF="youtube-dl -F"
# # alias youtube-mp4-full="youtube-dl --write-description --write-annotations --write-thumbnail --write-info-json --add-metadata --xattrs --merge-output-format mp4 --embed-thumbnail -f 'bestvideo+bestaudio'"
# alias youtube-mp4="youtube-dl \
#     --write-annotations \
#     --write-sub --write-auto-sub --sub-lang ko,en \
#     --add-metadata --xattrs --merge-output-format mp4 --embed-thumbnail \
#     -f 'bestvideo[ext=mp4]+bestaudio[ext=mp4]'"
#     alias youtube-webm="youtube-dl --write-description --write-annotations --write-thumbnail --write-info-json --add-metadata --xattrs -f 'bestvideo[ext=webm]+bestaudio[ext=webm]'"
#     # alias youtube-fhd "youtube-dl --write-description --write-annotations --write-thumbnail --write-info-json --add-metadata --xattrs --merge-output-format mp4 --embed-thumbnail -f 'bestvideo+bestaudio'"
#     alias youtube-thumbnail="youtube-dl --write-all-thumbnails"


# alias ranger=". ranger $2"
alias r='. ranger'
alias ra='ranger'
alias sra='sudo ranger'
alias f644='find . -type f -print0 | xargs -0 chmod 644'
alias d755='find . -type d -print0 | xargs -0 chmod 755'


alias rsz="rsync -ahz -X --zc=zstd --info=progress2"
alias rs="rsync -ah -X --info=progress2"
alias btrfsz="btrfs fi defrag -v -r -czstd"


### LS
if type exa > /dev/null; then
    alias et="exa --tree --icons --group --time-style long-iso"
    alias ls="exa --icons --group --time-style long-iso "
    alias ls2="exa --icons --group --time-style full-iso --no-permissions --octal-permissions"
elif type lsd > /dev/null; then
    alias et="lsd --tree"
    alias ls="lsd"
fi
alias l="/usr/bin/env ls -1A"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"


# ### Others
if type btm > /dev/null; then
    # alias btmb="btm --basic"
    alias btm="btm --hide_time --group --color default --battery --network_use_log -r 2000"
fi

if type upower > /dev/null; then
    alias bat-status="upower -i `upower -e | grep 'BAT'`"
    alias bat-status-short='upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage"'
fi

# ### Others2
alias sys="systemctl"
# alias wi="ranger '$HOME/Sync/Library/wiki'"
alias nn='n -UdE'
# alias wi="ranger '$HOME/Sync/Library/wiki'"
alias wi="lfcd '$HOME/Sync/Library/wiki'"
alias td="ranger '$HOME/Sync/Library/wiki/todo'"
alias st="ranger '$HOME/Sync/Study/Leetcode'"
alias powersave="sudo cpupower frequency-set -g powersave"

alias system-update="sudo pacman -Sy && sudo powerpill -Su && paru -Su"
alias system-cleanup='paccache -ruk0; paccache -rk1'

alias yay="paru"

type lfcd > /dev/null && alias lf="lfcd"

type asciidoctor > /dev/null 2>&1 \
    && alias asciidoctor="asciidoctor -a skip-front-matter"

type asciidoctor-pdf > /dev/null 2>&1 \
    && alias asciidoctor-pdf="asciidoctor-pdf -a skip-front-matter"
