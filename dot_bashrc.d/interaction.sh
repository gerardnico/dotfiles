#!/bin/bash


# Example of a more complex helper function
confirm() {
    read -r -p "${YELLOW}$1 [y/N] ${NC}" response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}