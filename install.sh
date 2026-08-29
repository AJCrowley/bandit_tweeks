#!/bin/sh

# Install fortune if it isn't already installed
if ! command -v fortune >/dev/null 2>&1; then
    echo "fortune not found; attempting to install it..."

    if command -v brew >/dev/null 2>&1; then
        brew install fortune

    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y fortune

    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y fortune

    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y fortune

    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --noconfirm fortune

    elif command -v apk >/dev/null 2>&1; then
        sudo apk add fortune

    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper install -y fortune

    elif command -v opkg >/dev/null 2>&1; then
        sudo opkg update
        sudo opkg install fortune

    elif command -v xbps-install >/dev/null 2>&1; then
        sudo xbps-install -y fortune

    else
        echo "ERROR: Could not determine a supported package manager."
        exit 1
    fi
fi

# Copy utilitylimb to its new home
sudo cp -r utilitylimb /usr/local/opt/

# Determine shell and corresponding rc file
if [ -n "$ZSH_VERSION" ]; then
    rcfile="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    rcfile="$HOME/.bashrc"
else
    echo "WARNING: Could not determine whether the shell is bash or zsh."
    exit 1
fi

# Add fortune invocation if it isn't already present
if ! grep -Fq 'fortune /usr/local/opt/utilitylimb' "$rcfile" 2>/dev/null; then
    echo 'fortune /usr/local/opt/utilitylimb' >> "$rcfile"
fi

echo "Installation complete."
echo "Restart your shell or run: source \"$rcfile\""

