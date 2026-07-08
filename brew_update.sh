#!/usr/bin/env bash
set -euo pipefail

if ! command -v brew &>/dev/null; then
    echo "Error: Homebrew is not installed." >&2
    exit 1
fi

echo "Fetching updates..."
brew update

echo
outdated=$(brew outdated --quiet)
if [[ -z "$outdated" ]]; then
    echo "Nothing to upgrade."
else
    echo "Packages that will be upgraded:"
    echo "$outdated"
    echo

    echo "Upgrading..."
    brew upgrade

    echo "Cleaning up..."
    brew cleanup
fi

echo
echo "Checking for vulnerabilities..."
vuln_output=$(brew vulns || true)
echo "$vuln_output"

vulnerable_packages=$(echo "$vuln_output" | grep -E '^[a-zA-Z0-9@_+-]+[[:space:]]+\(' | awk '{print $1}')
if [[ -n "$vulnerable_packages" ]]; then
    echo
    echo "Checking dependents of vulnerable packages..."
    while IFS= read -r pkg; do
        echo
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Package: $pkg"
        echo
        brew info "$pkg"
        echo
        echo "  Used by:"
        dependents=$(brew uses --installed "$pkg" 2>/dev/null || true)
        if [[ -n "$dependents" ]]; then
            while IFS= read -r dep; do
                echo "    - $dep"
            done <<< "$dependents"
        else
            echo "    - nothing installed depends on it"
        fi
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    done <<< "$vulnerable_packages"
fi

echo
echo "All done!"