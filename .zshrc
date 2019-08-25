#!/usr/bin/zsh

if [ !  -f ~/antigen.zsh ]; then
    echo Antigen not found, fetching latest version
    curl -L git.io/antigen > ~/antigen.zsh
fi

source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-completions

antigen apply

function startwm {
    file=emacs
    if [ "$1" = "i3" ]; then
        file=i3
    elif [ "$1" = "awesome" ]; then
        file=awesome
    fi
    cd
    startx ~/.xinitrcs/$file
    cd -
}

alias awexephyr="startx .xinitrcs/awesome -- /usr/bin/Xephyr -screen 1280x720"

export PROMPT='%n@%M:[%~] > '
