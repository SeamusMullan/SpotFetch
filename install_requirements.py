#!/usr/bin/env python3
# Simple script to install required packages for SpotFetch
import platform
import subprocess
import sys

def install_macos_requirements():
    print("Installing macOS-specific requirements...")
    try:
        # pyobjc is needed for Objective-C bridge on macOS
        subprocess.check_call(["uv", "pip", "install", "pyobjc"])
        print("Successfully installed macOS requirements")
    except subprocess.CalledProcessError:
        print("Error installing macOS requirements")
        sys.exit(1)

def main():
    if platform.system() == "Darwin":  # macOS
        install_macos_requirements()
    print("All requirements installed successfully")

if __name__ == "__main__":
    main()