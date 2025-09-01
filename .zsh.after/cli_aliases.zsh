# Enhanced CLI aliases and functions

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# List directory contents with colors and details
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -laht'  # Sort by time
alias lsize='ls -laS'  # Sort by size

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'

# System shortcuts
alias df='df -h'  # Human readable disk usage
alias du='du -h'  # Human readable directory sizes
alias free='free -h'  # Human readable memory
alias top='htop'  # Better top if available
alias ports='netstat -tulanp'  # Show open ports

# Quick navigation to common directories
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'
alias proj='cd ~/Projects'

# Enhanced grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enhanced find
alias findhere='find . -name'
alias findbig='find . -type f -size +100M'

# Quick file operations
alias cp='cp -i'  # Interactive copy
alias mv='mv -i'  # Interactive move
alias rm='rm -i'  # Interactive remove
alias mkdir='mkdir -p'  # Create parent directories

# Network shortcuts
alias myip='curl -s https://ipinfo.io/ip'
alias weather='curl -s wttr.in'
alias ping='ping -c 5'  # Limit ping to 5 packets

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias node='nodejs'

# Quick edit common config files
alias zshrc='nano ~/.zshrc'
alias starship='nano ~/.config/starship.toml'
alias tmux='nano ~/.tmux.conf.local'

# Function to create and navigate to directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Function to extract various archive types
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Function to show directory tree with git status
gtree() {
    if command -v tree >/dev/null 2>&1; then
        tree -a -I '.git|node_modules|__pycache__|*.pyc|.DS_Store' "$@"
    else
        echo "Install 'tree' command for better directory visualization"
        ls -la "$@"
    fi
}

# Function to show git log with file changes
git_log() {
    git log --stat --oneline "$@"
}

# Function to show disk usage for current directory
dus() {
    du -sh * | sort -hr
}

# Function to search for files by content
grepf() {
    if [ $# -eq 0 ]; then
        echo "Usage: grepf <pattern> [directory]"
        return 1
    fi
    local pattern="$1"
    local dir="${2:-.}"
    grep -r --color=auto "$pattern" "$dir"
}

# Function to show process tree
ptree() {
    if command -v pstree >/dev/null 2>&1; then
        pstree -p "$@"
    else
        ps auxf
    fi
}

# Function to show system info
sysinfo() {
    echo "=== System Information ==="
    echo "OS: $(lsb_release -d 2>/dev/null | cut -f2 || uname -a)"
    echo "Kernel: $(uname -r)"
    echo "Architecture: $(uname -m)"
    echo "Uptime: $(uptime -p)"
    echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
    echo "Memory: $(free -h | awk 'NR==2{printf "%.1f%%", $3*100/$2}')"
    echo "Disk: $(df -h / | awk 'NR==2{printf "%.1f%%", $5}')"
}

# Function to show git branch with status
gbranch() {
    local branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        echo "Current branch: $branch"
        git status --short
    fi
}

# Enhanced cd with history
cd() {
    builtin cd "$@"
    if [ $? -eq 0 ]; then
        # Add to directory history
        dirs -v | head -1 | cut -f2- | sed 's/^[0-9]* *//' >> ~/.zsh_dir_history 2>/dev/null
    fi
}

# Quick directory navigation
alias d='dirs -v'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
