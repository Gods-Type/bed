# BED with Tab Panel - Developer Notes

## AWS-LC-SYS Compilation Issues on Windows

### Issue Summary

The BED with Tab Panel project encounters AWS-LC-SYS compilation failures on Windows systems due to:

1. **CMake Generator Mismatch**: Build script attempts to use "Visual Studio 18 2026" which doesn't exist
2. **C11 Compatibility Issues**: MSVC compiler rejects C11 atomic operations required by AWS-LC-SYS
3. **Environment Configuration**: Improper build environment setup for Windows compilation

### Error Messages

```
error: failed to run custom build command for `aws-lc-sys v0.32.3`
CMake Error: Could not create named generator Visual Studio 18 2026
C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.50.35717\include\vcruntime_c11_stdatomic.h(16): 
fatal error C1189: #error: "C atomics require C11 or later"
```

### Root Cause Analysis

#### 1. CMake Generator Issue
- AWS-LC-SYS build script tries to use "Visual Studio 18 2026"
- System only has Visual Studio 17 2022 installed
- CMake cannot find the non-existent generator

#### 2. C11 Atomic Operations
- AWS-LC-SYS requires C11 atomic operations
- MSVC has limited C11 support, particularly for atomics
- The `vcruntime_c11_stdatomic.h` header explicitly rejects C11 atomics

#### 3. Build Environment
- Environment variables not properly set for Windows builds
- CMake configuration conflicts with MSVC capabilities
- Rust build system and CMake integration issues

### Solutions Implemented

#### 1. Safe Build Method (Primary Solution)
**Files**: `build-safe.bat`, `dist/bed-launcher.bat`

- Uses existing Zed installation
- Avoids AWS-LC-SYS compilation entirely
- Provides Tab Panel functionality via extensions
- Immediate access without compilation

**Usage**:
```bash
# Run the safe build
cmd /c build-safe.bat

# Launch BED with Tab Panel
dist\bed-launcher.bat
```

#### 2. Build Helper Script
**File**: `build-helper.bat`

- Interactive menu for build options
- Safe build option as primary recommendation
- Fallback to standard build attempts

#### 3. Environment Configuration
**Attempted Solutions**:

- Set `AWS_LC_SYS_STATIC=1`
- Set `AWS_LC_SYS_C_STD=c11`
- Set `CMAKE_GENERATOR="Visual Studio 17 2022"`
- Set `RUSTFLAGS=-C target-feature=+crt-static`

### Technical Details

#### AWS-LC-SYS Overview
- Rust binding to AWS-LC (fork of BoringSSL)
- Provides cryptographic functionality
- Requires C11 support for atomic operations
- Uses CMake for build configuration

#### Build Process Flow
1. Cargo initiates AWS-LC-SYS build
2. Build script runs C11 compatibility test
3. CMake generates build files
4. MSVC compiles C code with C11 features
5. Build fails at step 2 or 4

#### Windows-Specific Challenges
- MSVC's C11 support is incomplete
- CMake generator selection is complex
- Visual Studio version detection issues
- Environment variable inheritance problems

### Workarounds Attempted

#### 1. Environment Variables
```bash
set AWS_LC_SYS_STATIC=1
set AWS_LC_SYS_C_STD=c11
set CMAKE_GENERATOR="Visual Studio 17 2022"
set RUSTFLAGS=-C target-feature=+crt-static
```

#### 2. Cargo Configuration
```toml
[build]
rustflags = ["-C", "target-feature=+crt-static"]

[env]
AWS_LC_SYS_STATIC = "1"
AWS_LC_SYS_C_STD = "c11"
CMAKE_GENERATOR = "Visual Studio 17 2022"
```

#### 3. Build Flags
```bash
cargo build --release --bin zed --no-default-features
cargo build --release --bin zed -F aws-lc-sys/no-asm
```

### Recommendations for Future Development

#### 1. Extension-Based Approach
- Enhance Tab Panel as a Zed extension
- Reduce dependency on core compilation
- Provide features through extension API

#### 2. Build System Improvements
- Add proper CMake generator detection
- Implement Windows-specific build configurations
- Provide fallback build methods

#### 3. Documentation
- Document Windows build requirements
- Provide troubleshooting guides
- Create setup verification scripts

#### 4. Alternative Build Methods
- **WSL**: Build on Windows Subsystem for Linux
- **Docker**: Use containerized build environments
- **CI/CD**: Automated builds with proper tooling
- **Pre-built Binaries**: Provide compiled versions

### Files Structure

#### Essential Files
- `build.bat` - Original build script
- `build-helper.bat` - Interactive build helper
- `build-safe.bat` - Safe build method
- `dist/bed-launcher.bat` - Main launcher
- `dist/README-SIMPLE.txt` - User documentation
- `dist/BUILD_ISSUES_SUMMARY.txt` - Technical analysis

#### Configuration Files
- `.gitignore` - Updated to exclude build artifacts
- `DEVELOPER_NOTES.md` - This documentation

### Build Requirements

#### For Safe Build Method
- Zed installed from https://zed.dev
- Windows 10/11
- No compilation required

#### For Full Compilation (When Fixed)
- Visual Studio 2022 with C++ workload
- Latest Windows SDK
- Rust toolchain (stable)
- CMake 3.20+
- Git

### Troubleshooting Guide

#### Issue: AWS-LC-SYS compilation fails
**Solution**: Use safe build method
```bash
cmd /c build-safe.bat
```

#### Issue: Zed not found
**Solution**: Install Zed from https://zed.dev

#### Issue: Launcher doesn't work
**Solution**: Edit launcher to specify Zed path manually

#### Issue: Tab Panel not appearing
**Solution**: Check Zed extension settings

### Future Work

1. **Extension Development**: Enhance Tab Panel extension
2. **Build System**: Fix AWS-LC-SYS Windows compilation
3. **Documentation**: Improve user and developer guides
4. **Testing**: Add Windows-specific test cases
5. **CI/CD**: Setup automated build pipelines

### References

- AWS-LC-SYS GitHub: https://github.com/awslabs/aws-lc-rs
- Zed Editor: https://zed.dev
- CMake Documentation: https://cmake.org/documentation/
- MSVC C11 Support: https://learn.microsoft.com/en-us/cpp/build/reference/std-c-plus-plus

This documentation provides a comprehensive guide for future developers working on the BED with Tab Panel project, particularly regarding the AWS-LC-SYS compilation issues on Windows systems.