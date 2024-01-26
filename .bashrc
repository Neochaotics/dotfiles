# Neochaotics .bashrc

### EXPORT
export TERM="xterm-256color"            # getting proper colors
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export EDITOR="nvim"                    # $EDITOR use NEOVIM in terminal
export VISUAL="vscodium"                # $VISUAL use VSCODIUM in GUI mode
export OSH='/home/quinno/.oh-my-bash'   # Path to your oh-my-bash installation.

### SET MANPAGER
### "nvim" as manpager
export MANPAGER="nvim +Man!"

### ARCHIVE EXTRACTION
# usage: ex <file>
ex() {
	if [ -f "$1" ]; then
		case $1 in
		*.tar.bz2) tar xjf $1 ;;
		*.tar.gz) tar xzf $1 ;;
		*.bz2) bunzip2 $1 ;;
		*.rar) unrar x $1 ;;
		*.gz) gunzip $1 ;;
		*.tar) tar xf $1 ;;
		*.tbz2) tar xjf $1 ;;
		*.tgz) tar xzf $1 ;;
		*.zip) unzip $1 ;;
		*.Z) uncompress $1 ;;
		*.7z) 7z x $1 ;;
		*.deb) ar x $1 ;;
		*.tar.xz) tar xf $1 ;;
		*.tar.zst) unzstd $1 ;;
		*) echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

### ALIASES ###
alias vim="nvim"
alias config='/usr/bin/git --git-dir=/home/quinno/.cfg/ --work-tree=/home/quinno'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

### OH-MY-BASH
OSH_THEME="brainy" # Set name of the theme to load.

# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

ENABLE_CORRECTION="true"

completions=(
	git
	composer
	ssh
)

aliases=(
	general
	ls
)

plugins=(
	git
	bashmarks
	sudo
)

source "$OSH"/oh-my-bash.sh
