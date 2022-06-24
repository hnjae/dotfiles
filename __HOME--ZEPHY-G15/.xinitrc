#!/usr/bin/sh

# Make sure this is before the 'exec' command or it won't be sourced.
# [ -f /etc/xprofile ] && . /etc/xprofile
# [ -f ~/.xprofile ] && . ~/.xprofile

# for file in "/etc/profile" "$HOME/.profile" "/etc/xprofile" "$HOME/.xprofile"
# do
# 	if [ -f "$file" ]; then
# 		echo "Loading profile from $file";
# 		. "$file"
# 	fi
# done

case "$DESKTOP_SESSION" in
    '')
        echo "set DESKTOP_SESSION"
        exit 0
        ;;
    plasma)
	export XDG_SESSION_DESKTOP="KDE"
	export XDG_CURRENT_DESKTOP="KDE"
	;;
    *)
    	export XDG_SESSION_DESKTOP="$DESKTOP_SESSION"
    	export XDG_CURRENT_DESKTOP="$DESKTOP_SESSION"
        ;;
esac
export XDG_SESSION_TYPE="X11"

####################################################################################################
#
# /usr/share/sddm/scripts/Xsession 에서 참고
#
case $SHELL in
  */bash)
    [ -z "$BASH" ] && exec $SHELL $0 "$@"
    set +o posix
    [ -f /etc/profile ] && . /etc/profile
    if [ -f $HOME/.bash_profile ]; then
      . $HOME/.bash_profile
    elif [ -f $HOME/.bash_login ]; then
      . $HOME/.bash_login
    elif [ -f $HOME/.profile ]; then
      . $HOME/.profile
    fi
    ;;
*/zsh)
    [ -z "$ZSH_NAME" ] && exec $SHELL $0 "$@"
    [ -d /etc/zsh ] && zdir=/etc/zsh || zdir=/etc
    zhome=${ZDOTDIR:-$HOME}
    # zshenv is always sourced automatically.
    [ -f $zdir/zprofile ] && . $zdir/zprofile
    [ -f $zhome/.zprofile ] && . $zhome/.zprofile
    [ -f $zdir/zlogin ] && . $zdir/zlogin
    [ -f $zhome/.zlogin ] && . $zhome/.zlogin
    emulate -R sh
    ;;
  */csh|*/tcsh)
    # [t]cshrc is always sourced automatically.
    # Note that sourcing csh.login after .cshrc is non-standard.
    xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
    $SHELL -c "if (-f /etc/csh.login) source /etc/csh.login; if (-f ~/.login) source ~/.login; /bin/sh -c 'export -p' >! $xsess_tmp"
    . $xsess_tmp
    rm -f $xsess_tmp
    ;;
  */fish)
    xsess_tmp=`mktemp /tmp/xsess-env-XXXXXX`
    $SHELL --login -c "/bin/sh -c 'export -p' > $xsess_tmp"
    . $xsess_tmp
    rm -f $xsess_tmp
    ;;
  *) # Plain sh, ksh, and anything we do not know.
    [ -f /etc/profile ] && . /etc/profile
    [ -f $HOME/.profile ] && . $HOME/.profile
    ;;
esac

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f /usr/local/etc/xprofile ] && . /usr/local/etc/xprofile
[ -f $HOME/.xprofile ] && . $HOME/.xprofile

# run all system xinitrc shell scripts.
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/* ; do
  if [ -x "$i" ]; then
    . "$i"
  fi
  done
fi

# Load Xsession scripts
# OPTIONFILE, USERXSESSION, USERXSESSIONRC and ALTUSERXSESSION are required
# by the scripts to work
xsessionddir="/etc/X11/Xsession.d"
OPTIONFILE=/etc/X11/Xsession.options
USERXSESSION=$HOME/.xsession
USERXSESSIONRC=$HOME/.xsessionrc
ALTUSERXSESSION=$HOME/.Xsession

if [ -d "$xsessionddir" ]; then
    for i in `ls $xsessionddir`; do
        script="$xsessionddir/$i"
        echo "Loading X session script $script"
        if [ -r "$script"  -a -f "$script" ] && expr "$i" : '^[[:alnum:]_-]\{1,\}$' > /dev/null; then
            . "$script"
        fi
    done
fi

if [ -d /etc/X11/Xresources ]; then
  for i in /etc/X11/Xresources/*; do
    [ -f $i ] && xrdb -merge $i
  done
elif [ -f /etc/X11/Xresources ]; then
  xrdb -merge /etc/X11/Xresources
fi
[ -f $HOME/.Xresources ] && xrdb -merge $HOME/.Xresources

if [ -f "$USERXSESSIONRC" ]; then
  . "$USERXSESSIONRC"
fi
if [ -f "$USERXSESSION" ]; then
  . "$USERXSESSION"
fi

# if [ -z "$*" ]; then
#     exec xmessage -center -buttons OK:0 -default OK "Sorry, $DESKTOP_SESSION is no valid session."
# else
#     exec $@
# fi

####################################################################################################

# 2021-09-16 UNSET THIS VARIABLES TO MAKE THINGS WORK
# unset GDK_DPI_SCALE
# unset QT_FONT_DPI
/usr/bin/prime-offload
/usr/local/bin/xsetup-auto.sh

eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

case "$DESKTOP_SESSION" in
    plasma)
        exec startplasma-x11
        ;;
    i3)
        exec i3
        ;;
    *)
        echo "Use plasm or i3"
        ;;
esac
