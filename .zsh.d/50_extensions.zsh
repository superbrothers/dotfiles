for script in $(find $(dirname $0)/extentions -maxdepth 2 -type f -name "*.zsh"); do
    source $script
done
