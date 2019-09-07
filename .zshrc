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
    cd
    cp .xinitrcs/$1 .xinitrc
    startx
    cd -
}

function startxephyr {
    cd
    cp .xinitrcs/$1 .xinitrc
    startx -- /usr/bin/Xephyr -screen $2x$3
    cd -
}

export PROMPT='%n@%M:[%~] > '
