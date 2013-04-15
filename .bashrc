# Better path
PS1="\t \u@\h:\w$ "
PS1="\[\e[0;32m\]\u@\h\[\e[m\]:\[\e[1;33m\]\w\[\e[m\] \[\e[0;37m\]\A [\j]\$\[\e[m\] \[\e[0m\]"

# For default CoffeeLint settings
export COFFEELINT_CONFIG=~/.coffeelint.json

# Map ls to be colorful
alias ls='ls -GpFh'
# Nicer colors
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# JSON Viewing view python
alias json='python -mjson.tool'

# Colorized cat (nyan)
alias nyan='pygmentize -O style=friendly -f console256 -g'

# Tmux over screen
alias screen='tmux'

# MAC manipulators, via jashkenas
alias random_mac='sudo ifconfig en0 ether `openssl rand -hex 6 | sed "s/\(..\)/\1:/g; s/.$//"`'
alias restore_mac='sudo ifconfig en0 ether b8:8d:12:0b:30:30'

# Load local file if present
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi
