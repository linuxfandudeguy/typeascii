#!/bin/bash

cat << 'EOF' >> ~/.bashrc
# Define the typeascii function to handle ASCII art typing without border option
typeascii() {
    local text="$1"
    local style="$2"

    # Define color codes
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color

    # Function to handle typing effect
    type_text() {
        # Set default style if not provided
        local ascii_style="${style:-standard}"
        
        # Build the command
        local command="toilet -f $ascii_style"

        # Attempt to execute the command and handle errors
        if ! eval "echo \"$text\" | $command | pv -qL 100"; then
            echo -e "${RED}Error: Failed to execute the command. Ensure 'toilet' and 'pv' are installed and try again.${NC}"
        fi
    }

    # Check if text is provided as an argument
    if [ $# -gt 0 ]; then
        if [ $# -eq 1 ]; then
            type_text "$1"
        elif [ $# -eq 2 ]; then
            type_text "$1" "$2"
        else
            echo -e "${RED}Usage: $0 [text] [style]${NC}"
            return 1
        fi
    else
        # Prompt the user for text with color
        echo -e "${GREEN}What text do you want to type? ${NC}"
        read user_text

        # Prompt for style with color
        echo -e "${YELLOW}Enter ASCII art style (or press Enter to use default): ${NC}"
        read user_style

        # Set default style if not provided
        user_style="${user_style:-standard}"

        # Call type_text with user inputs
        type_text "$user_text" "$user_style"
    fi
}
EOF

# Reload .bashrc to apply changes
source ~/.bashrc
