# Root Zsh config pointing to custom dotfiles
# Please make all config adjustments there
export CUSTOM_ZSH_PATH="${${(%):-%x}:a:h}/.config/zsh";

source "$CUSTOM_ZSH_PATH/.zshrc";
