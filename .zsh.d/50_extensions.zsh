for script in $(find $(dirname $0)/extentions -type f -name "*.zsh" -maxdepth 2); do
    source $script
done

## brew info zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
