# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


ZSH_THEME="minimal"

plugins=(git
	git-prompt
	zsh-autosuggestions
	history-substring-search
	zsh-syntax-highlighting
	)

source $ZSH/oh-my-zsh.sh


#virtualenv setup for virtualenv location e homeproject
#export WORKON_HOME="$HOME/.virtualenvs"
#export PROJECT_HOME="$HOME/Projects"
#source $HOME/.local/bin/virtualenvwrapper.sh

#save history in cache
HISTFILE=$XDG_DATA_HOME/zsh_history
HISTSIZE=100000
SAVEHIST=100000


#basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots) #include hidden file


#vi mode
bindkey -v
export KEYTIMEOUT=1

#use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


#display when in normal mode
function zle-line-init zle-keymap-select {
	VIM_PROMPT="%{$fg_bold[green]%} [% NORMAL]% %{$reset_color%}"
	RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
eval "$(starship init zsh)"
