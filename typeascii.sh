# !!!DO NOT DELETE THIS SECTION!!!

# Function to type out the text using `toilet`, `pv`, and apply filters
typeascii() {
    local text="$1"
    local font="$2"
    local filter="$3"
    
    # Adjust typing speed to a balanced rate
    local rate="50"  # Speed in bytes per second (adjust as needed for balance)
    
    # Check if a filter is specified
    if [ -n "$filter" ]; then
        echo "$text" | toilet -f "$font" -F "$filter" | pv -qL "$rate"
    else
        echo "$text" | toilet -f "$font" | pv -qL "$rate"
    fi
}

# Color codes
COLOR_RESET="\033[0m"
COLOR_TEXT="\033[1;32m"   # Green for text input
COLOR_FONT="\033[1;34m"   # Blue for font selection
COLOR_FILTER="\033[1;35m" # Magenta for filter selection

# Function to display a colored prompt
colored_prompt() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${COLOR_RESET}"
}

# Check if an argument is provided
if [ $# -eq 0 ]; then
    # Prompt the user for text input
    colored_prompt "$COLOR_TEXT" "What text do you want to type? "
    read user_text
    
    # Prompt the user for the font
    colored_prompt "$COLOR_FONT" "Enter the font you want to use (e.g., standard, big, etc.): "
    read font_name

    # Prompt the user for the filter
    colored_prompt "$COLOR_FILTER" "Enter a filter to apply (e.g., 'gay', 'metal', or leave empty for none): "
    read filter_name

    # Validate the font
    if ! echo "$user_text" | toilet -f "$font_name" > /dev/null 2>&1; then
        echo "Invalid font. Using default font."
        font_name="standard"
    fi

    # Validate the filter
    if [ -n "$filter_name" ] && ! echo "$user_text" | toilet -F "$filter_name" > /dev/null 2>&1; then
        echo "Invalid filter. No filter will be applied."
        filter_name=""
    fi

    typeascii "$user_text" "$font_name" "$filter_name"
else
    # Use the provided arguments as the text, font, and optionally filter
    if [ $# -eq 1 ]; then
        typeascii "$1" "standard" ""  # Default font and no filter if only text is provided
    else
        if [ $# -eq 2 ]; then
            typeascii "$1" "$2" ""  # Default no filter if text and font are provided
        else
            if [ $# -eq 3 ]; then
                typeascii "$1" "$2" "$3"
            else
                echo "Invalid number of arguments."
                exit 1
            fi
        fi
    fi
fi
