for script in $(find $(dirname $0)/extensions -maxdepth 2 -type f -name "*.zsh"); do
    source $script
done
