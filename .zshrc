# ┌────────────────────────────────────────────────────────────────────────────┐
# │                           ZSH - MAIN ENTRY POINT                           │
# └────────────────────────────────────────────────────────────────────────────┘
# [INFO] This file sources all other configuration parts.
# Keep it clean and only add sourcing logic here.

# [CONFIG] Path to the Zsh configuration directory.
export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# [INFO] Source all .zsh files from the config directory.
# The numeric prefixes ensure they are loaded in the correct sequence.
for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do
  source "$config_file"
done

# [INFO] Clean up to avoid polluting the shell environment.
unset config_file
