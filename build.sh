#!/bin/bash

# Build script for Zed with Tab Panel
# This script compiles Zed with our Tab Panel modifications into a distributable .exe

set -e

echo "🚀 Building Zed with Tab Panel..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in the right directory
if [ ! -d "vendor/zed" ]; then
    print_error "vendor/zed directory not found. Please run this from the bed project root."
    exit 1
fi

# Check for required tools
check_required_tools() {
    print_status "Checking required tools..."
    
    if ! command -v rustc &> /dev/null; then
        print_error "Rust not found. Please install Rust from https://rustup.rs/"
        exit 1
    fi
    
    if ! command -v cargo &> /dev/null; then
        print_error "Cargo not found. Please install Rust from https://rustup.rs/"
        exit 1
    fi
    
    print_success "Required tools found!"
}

# Install Windows build target if not on Windows
install_windows_target() {
    if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "win32" && "$OSTYPE" != "win64" ]]; then
        print_status "Installing Windows target for cross-compilation..."
        rustup target add x86_64-pc-windows-msvc
        print_success "Windows target installed!"
    fi
}

# Build Zed in release mode
build_zed() {
    print_status "Building Zed with Tab Panel in release mode..."
    
    cd vendor/zed
    
    # Build with optimizations and Windows target
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "win64" ]]; then
        # On Windows, build directly
        cargo build --release --bin zed
    else
        # On other platforms, cross-compile for Windows
        cargo build --release --bin zed --target x86_64-pc-windows-msvc
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Zed built successfully!"
    else
        print_error "Build failed!"
        exit 1
    fi
    
    cd ../..
}

# Create distributable package
create_package() {
    print_status "Creating distributable package..."
    
    # Create output directory
    mkdir -p dist
    
    # Copy the executable
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "win64" ]]; then
        cp vendor/zed/target/release/zed.exe dist/bed-with-tab-panel.exe
    else
        cp vendor/zed/target/x86_64-pc-windows-msvc/release/zed.exe dist/bed-with-tab-panel.exe
    fi
    
    # Copy essential resources if they exist
    if [ -d "vendor/zed/crates/zed/resources" ]; then
        cp -r vendor/zed/crates/zed/resources dist/
    fi
    
    # Create a simple README for the package
    cat > dist/README.txt << EOF
BED with Tab Panel
==================

This is a custom build of Zed editor with the Tab Panel feature added.

Features:
- All standard Zed features
- New Tab Panel for managing tabs in a hierarchical view
- Toggle Tab Panel via View menu or action palette
- Tab Panel appears beside Project Panel

Installation:
1. Run bed-with-tab-panel.exe
2. The editor will start with Tab Panel enabled

To toggle Tab Panel:
- Go to View -> Tab Panel
- Or use the action palette and search for "Tab Panel"

This is an experimental build. Please report any issues.
EOF
    
    print_success "Package created in dist/ directory!"
}

# Create installer script
create_installer() {
    print_status "Creating installer script..."
    
    cat > dist/install.bat << 'EOF'
@echo off
echo Installing BED with Tab Panel...

REM Create installation directory
if not exist "%APPDATA%\BED" mkdir "%APPDATA%\BED"

REM Copy files
copy "bed-with-tab-panel.exe" "%APPDATA%\BED\"
if exist "resources" xcopy /E /I /Y "resources" "%APPDATA%\BED\resources\"

REM Create desktop shortcut
powershell "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\BED with Tab Panel.lnk'); $Shortcut.TargetPath = '%APPDATA%\BED\bed-with-tab-panel.exe'; $Shortcut.Save()"

REM Add to PATH (optional)
echo Adding to PATH...
setx PATH "%PATH%;%APPDATA%\BED" /M

echo Installation complete!
echo You can now run BED with Tab Panel from your desktop or start menu.
pause
EOF

    print_success "Installer script created!"
}

# Main execution
main() {
    echo "🎯 BED with Tab Panel Build Script"
    echo "=================================="
    echo
    
    check_required_tools
    install_windows_target
    build_zed
    create_package
    create_installer
    
    echo
    print_success "Build complete! 🎉"
    echo
    echo "📦 Output files:"
    echo "   - dist/bed-with-tab-panel.exe  (Main executable)"
    echo "   - dist/install.bat             (Windows installer)"
    echo "   - dist/README.txt              (Documentation)"
    echo
    echo "🚀 To install:"
    echo "   1. Run dist/install.bat on Windows"
    echo "   2. Or directly run bed-with-tab-panel.exe"
    echo
}

# Run main function
main "$@"