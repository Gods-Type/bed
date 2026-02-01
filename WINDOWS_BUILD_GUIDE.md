# Windows Build Guide for BED with Tab Panel

## Table of Contents

1. [Introduction](#introduction)
2. [System Requirements](#system-requirements)
3. [Build Methods](#build-methods)
   - [Safe Build Method (Recommended)](#safe-build-method-recommended)
   - [Standard Build Method](#standard-build-method)
   - [Build Helper](#build-helper)
4. [Troubleshooting](#troubleshooting)
   - [AWS-LC-SYS Issues](#aws-lc-sys-issues)
   - [Visual Studio Configuration](#visual-studio-configuration)
   - [Environment Variables](#environment-variables)
5. [Advanced Solutions](#advanced-solutions)
   - [WSL Build](#wsl-build)
   - [Docker Build](#docker-build)
   - [Manual Patching](#manual-patching)
6. [File Structure](#file-structure)
7. [FAQ](#faq)

## Introduction

This guide provides comprehensive instructions for building BED with Tab Panel on Windows systems. Due to AWS-LC-SYS compilation issues, we recommend the safe build method for most users.

## System Requirements

### For Safe Build Method
- **Operating System**: Windows 10 or 11 (64-bit)
- **Zed Editor**: Installed from https://zed.dev
- **Disk Space**: 500MB free space
- **Memory**: 4GB RAM minimum

### For Standard Build Method (When Working)
- **Operating System**: Windows 10 or 11 (64-bit)
- **Visual Studio 2022**: With C++ workload
- **Windows SDK**: Latest version
- **Rust Toolchain**: Stable version (1.70+)
- **CMake**: Version 3.20+
- **Git**: Latest version
- **Disk Space**: 20GB free space
- **Memory**: 8GB RAM recommended

## Build Methods

### Safe Build Method (Recommended)

This method avoids AWS-LC-SYS compilation issues by using an existing Zed installation.

#### Steps:

1. **Install Zed Editor**
   ```bash
   # Download from https://zed.dev
   # Install using the provided installer
   ```

2. **Run Safe Build**
   ```bash
   cmd /c build-safe.bat
   ```

3. **Launch BED with Tab Panel**
   ```bash
   dist\bed-launcher.bat
   ```

#### Expected Output:
- `dist/bed-launcher.bat` - Main launcher
- `dist/README-SIMPLE.txt` - Documentation
- `dist/BUILD_ISSUES_SUMMARY.txt` - Technical details

#### Benefits:
- ✅ No compilation required
- ✅ Immediate access
- ✅ Stable and reliable
- ✅ Avoids AWS-LC-SYS issues

### Standard Build Method

This method attempts to compile Zed with Tab Panel from source.

#### Steps:

1. **Install Prerequisites**
   ```bash
   # Install Visual Studio 2022 with C++ workload
   # Install Rust: https://rustup.rs/
   # Install CMake: https://cmake.org/download/
   ```

2. **Run Standard Build**
   ```bash
   cmd /c build.bat
   ```

#### Expected Issues:
- AWS-LC-SYS compilation failures (see Troubleshooting)
- CMake generator mismatches
- C11 compatibility errors

#### Workarounds:
- Use `build-helper.bat` for alternative approaches
- Try environment variable overrides
- Consider WSL or Docker builds

### Build Helper

Interactive build helper with multiple options.

#### Usage:
```bash
cmd /c build-helper.bat
```

#### Options:
1. **Standard Build** - Attempts full compilation
2. **Safe Build** - Uses existing Zed installation (recommended)

## Troubleshooting

### AWS-LC-SYS Issues

#### Error: "Could not create named generator Visual Studio 18 2026"

**Cause**: AWS-LC-SYS tries to use a non-existent CMake generator.

**Solutions**:
1. Use safe build method
2. Set correct generator: `set CMAKE_GENERATOR="Visual Studio 17 2022"`
3. Try Ninja generator: `set CMAKE_GENERATOR="Ninja"`

#### Error: "C atomics require C11 or later"

**Cause**: MSVC has limited C11 support for atomics.

**Solutions**:
1. Use safe build method
2. Try different Visual Studio versions
3. Use WSL or Linux for compilation

### Visual Studio Configuration

#### Required Workloads:
- Desktop development with C++
- Universal Windows Platform development
- C++ CMake tools for Windows

#### Installation:
```bash
# Run Visual Studio Installer
# Select "Desktop development with C++" workload
# Include CMake tools and Windows SDK
```

### Environment Variables

#### For Standard Build:
```bash
set AWS_LC_SYS_STATIC=1
set AWS_LC_SYS_C_STD=c11
set CMAKE_GENERATOR="Visual Studio 17 2022"
set RUSTFLAGS=-C target-feature=+crt-static
```

#### For Safe Build:
```bash
# No environment variables needed
# Just ensure Zed is installed
```

## Advanced Solutions

### WSL Build

Build on Windows Subsystem for Linux.

#### Steps:
```bash
# Install WSL 2
wsl --install

# Install Ubuntu
wsl --install -d Ubuntu

# Install dependencies
sudo apt update
sudo apt install build-essential cmake git curl

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Clone and build
git clone https://github.com/Gods-Type/bed.git
cd bed
./build.bat
```

### Docker Build

Use containerized build environment.

#### Dockerfile:
```dockerfile
FROM rust:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    libssl-dev

WORKDIR /app
COPY . .

RUN ./build.bat
```

#### Build:
```bash
docker build -t bed-builder .
docker run -v C:\path\to\output:/output bed-builder
```

### Manual Patching

For advanced users who want to fix AWS-LC-SYS.

#### Steps:
1. Fork AWS-LC-SYS repository
2. Modify CMake configuration
3. Update C11 compatibility checks
4. Test with different MSVC versions
5. Submit pull request

## File Structure

### Essential Files
```
bed/
├── build.bat                  # Original build script
├── build-helper.bat           # Interactive build helper
├── build-safe.bat             # Safe build method
├── dist/
│   ├── bed-launcher.bat       # Main launcher
│   ├── README-SIMPLE.txt      # User documentation
│   ├── BUILD_ISSUES_SUMMARY.txt # Technical analysis
│   └── resources/             # Zed resources
├── vendor/zed/                # Zed source code
├── .gitignore                 # Git ignore rules
├── DEVELOPER_NOTES.md         # Developer documentation
└── WINDOWS_BUILD_GUIDE.md     # This guide
```

### Build Artifacts (Ignored)
```
# These are ignored by .gitignore
vendor/zed/target/
*.exe (except in dist/)
*.dll
*.pdb
build-output/
temp/
```

## FAQ

### Q: Why does the build fail on Windows?
A: The AWS-LC-SYS crate has C11 compatibility issues with MSVC. We recommend the safe build method.

### Q: Can I use the safe build without installing Zed?
A: No, the safe build requires Zed to be installed from https://zed.dev.

### Q: How do I get Tab Panel functionality?
A: The safe build provides Tab Panel through Zed's extension system. Install Zed and use our launcher.

### Q: Will the standard build ever work on Windows?
A: We're working on fixes. Check the GitHub repository for updates.

### Q: Can I help fix the AWS-LC-SYS issue?
A: Yes! See the "Manual Patching" section and contribute to the AWS-LC-SYS project.

### Q: What if I need full compilation?
A: Try WSL or Docker builds, or use Linux for development.

### Q: How do I update to new versions?
A: Run `git pull` and rebuild using your preferred method.

### Q: Where can I get support?
A: Check the GitHub repository issues or consult the developer notes.

## Conclusion

For most users, the **safe build method** is recommended:

```bash
# Install Zed from https://zed.dev
cmd /c build-safe.bat
dist\bed-launcher.bat
```

For advanced users, consider WSL or Docker builds. Check the developer notes for technical details about the AWS-LC-SYS issues.

This guide will be updated as we improve Windows compatibility. Check the GitHub repository for the latest information.