#!usr/bin/bash

# # This was very helpful for debugging:
# log_file="$HOME/lf-reflink-log-$(date +'%Y-%m-%d_%H-%M-%S')"
# [ -f "$log_file" ] || touch "$log_file"
# exec 1>> $log_file 2>&1
# set -x

# In theory, this may fail,
# but I tested it on selection with 10k files - everything worked (bash)
set -- $(cat ~/.local/share/lf/files)
mode="$1"
shift

if [ $mode = 'copy' ]; then
    # Reflink if all items of selection and the destination are on the
    # same mount point and it is CoW fs.
    # (to make sure reflink never fails in first place, so we don't have to
    # clean up)

    src_targets="$(df --output=target -- "$@" | sed '1d' | sort -u)"

    if [ "$(df --output=target -- "$PWD" | tail -n 1)" = \
         "$(echo "$src_targets" | tail -n 1)" ] && \
         (( "$(echo "$src_targets" | wc -l)" == 1 )) && \
         [[ "$(df --output=fstype -- "$PWD" | tail -n 1)" =~ ^(btrfs|xfs|zfs)$ ]]; then

        echo 'selected copy and cp reflink paste'

        start=$(date '+%s')

        # Handle same names in dst
        # TODO parallelism, idk - but exit/return/break won't stop the loop from subshell...
        for i in "$@"; do
            name="${i##*/}"
            original="$name"

            count=0
            while [ -w "$PWD/$name" ]; do
                count=$((count+1))
                name="$original.~$count~"
            done

            set +e
            cp_out="$(cp -rn --reflink=always -- "$i" "$PWD/$name" 2>&1)"
            set -e

            if [ ! -z "$cp_out" ]; then
                lf -remote "send $id echoerr $cp_out"
                exit 0
            fi
        done

        finish=$(( $(date '+%s') - $start ))
        t=''
        if (( $finish > 2 )); then
            t="${finish}s"
        fi

        # Or just skip a file when names are the same.
        # (A LOT faster if you e.g. pasting selection of 10k files)
        # cp -rn --reflink=always -- "$@" .

        lf -remote "send clear"

        green=$'\u001b[32m'
        reset=$'\u001b[0m'
        lf -remote "send $id echo ${green}reflinked!${reset} $t"
    else
        echo 'selected copy and lf native paste'
        lf -remote "send $id paste"
    fi

elif [ $mode = 'move' ]; then
    echo 'selected move and lf native paste'
    lf -remote "send $id paste"
fi

# # for debug
# set +x

lf -remote "send load"
