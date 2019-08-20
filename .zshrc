#!/usr/bin/zsh

if [ !  -f ~/antigen.zsh ]; then
    echo Antigen not found, fetching latest version
    curl -L git.io/antigen > ~/antigen.zsh
fi

source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-completions

antigen apply

export PROMPT='%n@%M:[%d] > '
