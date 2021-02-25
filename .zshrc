#Mack's zinitrc running zinit
if [ "$(tty)" = "/dev/tty1" ]; then
	sway 2> ~/.sway_log && /usr/bin/zsh
fi
#Start loading, Starting with Loacale and Paths
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
export LC_ALL=en_US.UTF-8 
export fpath=("$HOME/.zprompts" "$fpath[@]") # add .zprompts to fpath

# Load History variables
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=9999999

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager aka zinit also installing my theme…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful, installing theme.%f%b" && \
        command mkdir -p $HOME/.zprompts && wget https://raw.githubusercontent.com/mackdroid/agnoster-zsh-theme/master/agnoster.zsh-theme -O $HOME/.zprompts/prompt_macky_setup && \
        print -P "%F{33}▓▒░ %F{34}Installing theme successful"  || \
        print -P "%F{160}▓▒░ The clone or the theme failed installing remove ~/.zinit and try again .%f%b"
        print -P "%F{160}▓▒░ note you need git and wget for this so make sure you have that"
fi
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load zinit 
source "$HOME/.zinit/bin/zinit.zsh"

# some completion thing
zinit light RobSis/zsh-completion-generator

# Load colours
autoload -U colors && colors

# Load compinit
autoload -Uz compinit && compinit
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*' menu select

# Load bashcompinit
autoload -U +X bashcompinit && bashcompinit

zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
#   Aloxaf/fzf-tab \

# Load promptinit for custom prompt
mkdir -p $HOME/.zprompts
autoload -Uz promptinit && promptinit

# Load Theme
# use these variables to set theme appearance
# use the colours command if you want to customize your prompt
# colour of segment 1, the Username segemen
Seg1=57
# colour of segment 2, the hostname segement
Seg2=63
# colour of segment 3, directory segement
Seg3=69
# sets foreground of the segements use default or white for white or black for black
Segf1=default 
Segf2=default
Segf3=default
prompt macky # set prompt theme you can change it if you like pop the zsh theme into ~/.zprompts 
             # and name it prompt_<name of theme>_setup and replace macky the default theme with 
             # your theme name

### End of Zinit's installer chunk

#
# Load Keybinds
#

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
  bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
  bindkey -M emacs "${terminfo[knp]}" down-line-or-history
  bindkey -M viins "${terminfo[knp]}" down-line-or-history
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
  bindkey -M emacs "${terminfo[khome]}" beginning-of-line
  bindkey -M viins "${terminfo[khome]}" beginning-of-line
  bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
  bindkey -M emacs "${terminfo[kend]}"  end-of-line
  bindkey -M viins "${terminfo[kend]}"  end-of-line
  bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - delete backward
bindkey -M emacs '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
  bindkey -M emacs "${terminfo[kdch1]}" delete-char
  bindkey -M viins "${terminfo[kdch1]}" delete-char
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
  bindkey -M emacs "^[[3~" delete-char
  bindkey -M viins "^[[3~" delete-char
  bindkey -M vicmd "^[[3~" delete-char

  bindkey -M emacs "^[3;5~" delete-char
  bindkey -M viins "^[3;5~" delete-char
  bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word


bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - dont do history expansion

#
# Few Unimportant Aliases and functions 
#

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -10
  fi
}
compdef _dirs d

# List directory contents
alias lsa='ls -lah --color'
alias l='ls -lah --color'
alias ll='ls -lh --color'
alias la='ls -lAh --color'
alias ls='/usr/bin/ls --color'

# function to print all 256 colours
colours(){
	echo "[38;5;15m  0[0m [48;5;1m[38;5;0m  1[0m [48;5;2m[38;5;0m  2[0m [48;5;3m[38;5;0m  3[0m [48;5;4m[38;5;0m  4[0m [48;5;5m[38;5;0m  5[0m [48;5;6m[38;5;0m  6[0m [48;5;7m[38;5;0m  7[0m [48;5;8m[38;5;0m  8[0m [48;5;9m[38;5;0m  9[0m [48;5;10m[38;5;0m 10[0m [48;5;11m[38;5;0m 11[0m [48;5;12m[38;5;0m 12[0m [48;5;13m[38;5;0m 13[0m [48;5;14m[38;5;0m 14[0m [48;5;15m[38;5;0m 15[0m   
	
[48;5;16m[38;5;15m 16[0m [48;5;17m[38;5;15m 17[0m [48;5;18m[38;5;15m 18[0m [48;5;19m[38;5;15m 19[0m [48;5;20m[38;5;15m 20[0m [48;5;21m[38;5;15m 21[0m   [48;5;52m[38;5;15m 52[0m [48;5;53m[38;5;15m 53[0m [48;5;54m[38;5;15m 54[0m [48;5;55m[38;5;15m 55[0m [48;5;56m[38;5;15m 56[0m [48;5;57m[38;5;15m 57[0m   [48;5;88m[38;5;15m 88[0m [48;5;89m[38;5;15m 89[0m [48;5;90m[38;5;15m 90[0m [48;5;91m[38;5;15m 91[0m [48;5;92m[38;5;15m 92[0m [48;5;93m[38;5;15m 93[0m   
[48;5;22m[38;5;15m 22[0m [48;5;23m[38;5;15m 23[0m [48;5;24m[38;5;15m 24[0m [48;5;25m[38;5;15m 25[0m [48;5;26m[38;5;15m 26[0m [48;5;27m[38;5;15m 27[0m   [48;5;58m[38;5;15m 58[0m [48;5;59m[38;5;15m 59[0m [48;5;60m[38;5;15m 60[0m [48;5;61m[38;5;15m 61[0m [48;5;62m[38;5;15m 62[0m [48;5;63m[38;5;15m 63[0m   [48;5;94m[38;5;15m 94[0m [48;5;95m[38;5;15m 95[0m [48;5;96m[38;5;15m 96[0m [48;5;97m[38;5;15m 97[0m [48;5;98m[38;5;15m 98[0m [48;5;99m[38;5;15m 99[0m   
[48;5;28m[38;5;15m 28[0m [48;5;29m[38;5;15m 29[0m [48;5;30m[38;5;15m 30[0m [48;5;31m[38;5;15m 31[0m [48;5;32m[38;5;15m 32[0m [48;5;33m[38;5;15m 33[0m   [48;5;64m[38;5;15m 64[0m [48;5;65m[38;5;15m 65[0m [48;5;66m[38;5;15m 66[0m [48;5;67m[38;5;15m 67[0m [48;5;68m[38;5;15m 68[0m [48;5;69m[38;5;15m 69[0m   [48;5;100m[38;5;15m100[0m [48;5;101m[38;5;15m101[0m [48;5;102m[38;5;15m102[0m [48;5;103m[38;5;15m103[0m [48;5;104m[38;5;15m104[0m [48;5;105m[38;5;15m105[0m   
[48;5;34m[38;5;0m 34[0m [48;5;35m[38;5;0m 35[0m [48;5;36m[38;5;0m 36[0m [48;5;37m[38;5;0m 37[0m [48;5;38m[38;5;0m 38[0m [48;5;39m[38;5;0m 39[0m   [48;5;70m[38;5;0m 70[0m [48;5;71m[38;5;0m 71[0m [48;5;72m[38;5;0m 72[0m [48;5;73m[38;5;0m 73[0m [48;5;74m[38;5;0m 74[0m [48;5;75m[38;5;0m 75[0m   [48;5;106m[38;5;0m106[0m [48;5;107m[38;5;0m107[0m [48;5;108m[38;5;0m108[0m [48;5;109m[38;5;0m109[0m [48;5;110m[38;5;0m110[0m [48;5;111m[38;5;0m111[0m   
[48;5;40m[38;5;0m 40[0m [48;5;41m[38;5;0m 41[0m [48;5;42m[38;5;0m 42[0m [48;5;43m[38;5;0m 43[0m [48;5;44m[38;5;0m 44[0m [48;5;45m[38;5;0m 45[0m   [48;5;76m[38;5;0m 76[0m [48;5;77m[38;5;0m 77[0m [48;5;78m[38;5;0m 78[0m [48;5;79m[38;5;0m 79[0m [48;5;80m[38;5;0m 80[0m [48;5;81m[38;5;0m 81[0m   [48;5;112m[38;5;0m112[0m [48;5;113m[38;5;0m113[0m [48;5;114m[38;5;0m114[0m [48;5;115m[38;5;0m115[0m [48;5;116m[38;5;0m116[0m [48;5;117m[38;5;0m117[0m   
[48;5;46m[38;5;0m 46[0m [48;5;47m[38;5;0m 47[0m [48;5;48m[38;5;0m 48[0m [48;5;49m[38;5;0m 49[0m [48;5;50m[38;5;0m 50[0m [48;5;51m[38;5;0m 51[0m   [48;5;82m[38;5;0m 82[0m [48;5;83m[38;5;0m 83[0m [48;5;84m[38;5;0m 84[0m [48;5;85m[38;5;0m 85[0m [48;5;86m[38;5;0m 86[0m [48;5;87m[38;5;0m 87[0m   [48;5;118m[38;5;0m118[0m [48;5;119m[38;5;0m119[0m [48;5;120m[38;5;0m120[0m [48;5;121m[38;5;0m121[0m [48;5;122m[38;5;0m122[0m [48;5;123m[38;5;0m123[0m   

[48;5;124m[38;5;15m124[0m [48;5;125m[38;5;15m125[0m [48;5;126m[38;5;15m126[0m [48;5;127m[38;5;15m127[0m [48;5;128m[38;5;15m128[0m [48;5;129m[38;5;15m129[0m   [48;5;160m[38;5;15m160[0m [48;5;161m[38;5;15m161[0m [48;5;162m[38;5;15m162[0m [48;5;163m[38;5;15m163[0m [48;5;164m[38;5;15m164[0m [48;5;165m[38;5;15m165[0m   [48;5;196m[38;5;15m196[0m [48;5;197m[38;5;15m197[0m [48;5;198m[38;5;15m198[0m [48;5;199m[38;5;15m199[0m [48;5;200m[38;5;15m200[0m [48;5;201m[38;5;15m201[0m   
[48;5;130m[38;5;15m130[0m [48;5;131m[38;5;15m131[0m [48;5;132m[38;5;15m132[0m [48;5;133m[38;5;15m133[0m [48;5;134m[38;5;15m134[0m [48;5;135m[38;5;15m135[0m   [48;5;166m[38;5;15m166[0m [48;5;167m[38;5;15m167[0m [48;5;168m[38;5;15m168[0m [48;5;169m[38;5;15m169[0m [48;5;170m[38;5;15m170[0m [48;5;171m[38;5;15m171[0m   [48;5;202m[38;5;15m202[0m [48;5;203m[38;5;15m203[0m [48;5;204m[38;5;15m204[0m [48;5;205m[38;5;15m205[0m [48;5;206m[38;5;15m206[0m [48;5;207m[38;5;15m207[0m   
[48;5;136m[38;5;15m136[0m [48;5;137m[38;5;15m137[0m [48;5;138m[38;5;15m138[0m [48;5;139m[38;5;15m139[0m [48;5;140m[38;5;15m140[0m [48;5;141m[38;5;15m141[0m   [48;5;172m[38;5;15m172[0m [48;5;173m[38;5;15m173[0m [48;5;174m[38;5;15m174[0m [48;5;175m[38;5;15m175[0m [48;5;176m[38;5;15m176[0m [48;5;177m[38;5;15m177[0m   [48;5;208m[38;5;15m208[0m [48;5;209m[38;5;15m209[0m [48;5;210m[38;5;15m210[0m [48;5;211m[38;5;15m211[0m [48;5;212m[38;5;15m212[0m [48;5;213m[38;5;15m213[0m   
[48;5;142m[38;5;0m142[0m [48;5;143m[38;5;0m143[0m [48;5;144m[38;5;0m144[0m [48;5;145m[38;5;0m145[0m [48;5;146m[38;5;0m146[0m [48;5;147m[38;5;0m147[0m   [48;5;178m[38;5;0m178[0m [48;5;179m[38;5;0m179[0m [48;5;180m[38;5;0m180[0m [48;5;181m[38;5;0m181[0m [48;5;182m[38;5;0m182[0m [48;5;183m[38;5;0m183[0m   [48;5;214m[38;5;0m214[0m [48;5;215m[38;5;0m215[0m [48;5;216m[38;5;0m216[0m [48;5;217m[38;5;0m217[0m [48;5;218m[38;5;0m218[0m [48;5;219m[38;5;0m219[0m   
[48;5;148m[38;5;0m148[0m [48;5;149m[38;5;0m149[0m [48;5;150m[38;5;0m150[0m [48;5;151m[38;5;0m151[0m [48;5;152m[38;5;0m152[0m [48;5;153m[38;5;0m153[0m   [48;5;184m[38;5;0m184[0m [48;5;185m[38;5;0m185[0m [48;5;186m[38;5;0m186[0m [48;5;187m[38;5;0m187[0m [48;5;188m[38;5;0m188[0m [48;5;189m[38;5;0m189[0m   [48;5;220m[38;5;0m220[0m [48;5;221m[38;5;0m221[0m [48;5;222m[38;5;0m222[0m [48;5;223m[38;5;0m223[0m [48;5;224m[38;5;0m224[0m [48;5;225m[38;5;0m225[0m   
[48;5;154m[38;5;0m154[0m [48;5;155m[38;5;0m155[0m [48;5;156m[38;5;0m156[0m [48;5;157m[38;5;0m157[0m [48;5;158m[38;5;0m158[0m [48;5;159m[38;5;0m159[0m   [48;5;190m[38;5;0m190[0m [48;5;191m[38;5;0m191[0m [48;5;192m[38;5;0m192[0m [48;5;193m[38;5;0m193[0m [48;5;194m[38;5;0m194[0m [48;5;195m[38;5;0m195[0m   [48;5;226m[38;5;0m226[0m [48;5;227m[38;5;0m227[0m [48;5;228m[38;5;0m228[0m [48;5;229m[38;5;0m229[0m [48;5;230m[38;5;0m230[0m [48;5;231m[38;5;0m231[0m   

[48;5;232m[38;5;15m232[0m [48;5;233m[38;5;15m233[0m [48;5;234m[38;5;15m234[0m [48;5;235m[38;5;15m235[0m [48;5;236m[38;5;15m236[0m [48;5;237m[38;5;15m237[0m [48;5;238m[38;5;15m238[0m [48;5;239m[38;5;15m239[0m [48;5;240m[38;5;15m240[0m [48;5;241m[38;5;15m241[0m [48;5;242m[38;5;15m242[0m [48;5;243m[38;5;15m243[0m   
[48;5;244m[38;5;0m244[0m [48;5;245m[38;5;0m245[0m [48;5;246m[38;5;0m246[0m [48;5;247m[38;5;0m247[0m [48;5;248m[38;5;0m248[0m [48;5;249m[38;5;0m249[0m [48;5;250m[38;5;0m250[0m [48;5;251m[38;5;0m251[0m [48;5;252m[38;5;0m252[0m [48;5;253m[38;5;0m253[0m [48;5;254m[38;5;0m254[0m [48;5;255m[38;5;0m255[0m   "
}

command_not_found_handler() {
	local pkgs cmd="$1" files=()
	printf 'zsh: command not found: %s' "$cmd" # print command not found asap, then search for packages
	files=(${(f)"$(pkgfile --binaries --verbose --  "/usr/bin/${cmd}")"})
	if (( ${#files[@]} )); then
		printf '\r%s may be found in the following packages:\n' "$cmd"
		local res=() repo package version file
		for file in "$files[@]"; do
			res=("${(0)file}")
			repo="$res[1]"
			package="$res[2]"
			version="$res[3]"
			file="$res[4]"
			printf '%s%s%s%s\n' "$repo" "$package" "$version" "$file"
		done
	else
		printf '\n'
	fi
	return 127
}

wlstream() {
	export XDG_CURRENT_DESKTOP=sway
	echo "killing all xdg desktop portal instances..."
	killall /usr/lib/xdg-desktop-portal-wlr /usr/lib/xdg-desktop-portal
	echo "Done, waiting for a few seconds"
	sleep 2
    /usr/lib/xdg-desktop-portal-wlr &

}

#
# User configuration
#

alias nano=micro
alias upgrade="yay -Syu"
alias cdd="cd ~/Downloads"
alias search="yay -Ss "
alias query="yay -Qs "
alias boomer="neofetch --ascii_distro gentoo"
alias reload="source ~/.zshrc"
alias hackerman="neofetch --ascii_distro kali"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
