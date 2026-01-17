# 📁 Git Strategy for BED with Tab Panel

## Overview
This project uses a comprehensive .gitignore strategy to:
- ✅ Keep repository size small
- ✅ Avoid committing build artifacts
- ✅ Protect user privacy
- ✅ Enable smooth development workflow

## 📋 What's Ignored & Why

### 🏗️ Build Artifacts
```
/dist/*.exe          # Compiled executables
/vendor/zed/**/*.exe   # Vendor binaries
/target/             # Cargo build outputs
*.dll, *.so, *.dylib # Dynamic libraries
*.pdb               # Debug symbols
```

**Reason**: Build artifacts should be regenerated, not stored in git.

### 🔧 Development Files
```
.vscode/, .idea/     # Editor configurations
*.swp, *.swo        # Vim swap files
*~, *.bak, *.old    # Backup and temporary files
.env, .env.local      # Environment variables
```

**Reason**: Personal development settings and temporary files.

### 📦 Dependencies
```
vendor/zed/target/     # Vendor build outputs
Cargo.lock            # Lock files (optional)
node_modules/         # Node dependencies
```

**Reason**: Dependencies can be regenerated and shouldn't be committed.

## 📁 What's Kept in Git

### ✅ Source Code
```
vendor/zed/           # Zed source code (essential)
crates/tab_panel/     # Our Tab Panel implementation
*.rs                 # All source files
```

### ✅ Configuration
```
.gitignore           # Git ignore rules
*.toml              # Project configuration
build-*.bat         # Our build scripts
install.bat          # Our installer
README.md            # Documentation
```

### ✅ Build Structure
```
dist/.gitkeep        # Directory marker
```

## 🔧 Development Workflow

### Adding New Features
1. **Code**: Edit source files in `crates/tab_panel/`
2. **Build**: Run `build-complete.bat`
3. **Test**: Use generated `dist/*.exe`
4. **Commit**: Only source changes are tracked
5. **Release**: Build clean distribution package

### Build Process
```
git clone <repo>
cd bed
./build-complete.bat    # Creates dist/ with executables
```

### Clean Build
```
git clean -fd         # Remove all untracked files
./build-complete.bat    # Fresh build
```

## ⚠️ Special Cases

### Vendor Directory Strategy
- **Keep**: `vendor/zed/` source code (needed for building)
- **Ignore**: `vendor/zed/target/` and binaries
- **Rationale**: Source is essential, builds are reproducible

### Distribution Directory Strategy  
- **Keep**: `dist/` directory structure
- **Ignore**: `dist/*.exe` and binaries
- **Rationale**: Users can build locally, no need to ship binaries

## 🔄 Changing Git Ignore Rules

### Adding New Patterns
Add to `.gitignore`:
```gitignore
# New build output pattern
*.new_artifact
/new_temp_dir/
```

### Temporarily Ignoring Files
```bash
# Temporary ignore file
git update-index --assume-unchanged path/to/file
git commit -m "Commit with ignored file"
```

### Checking What's Ignored
```bash
git status --ignored
git check-ignore path/to/file
```

## 🎯 Best Practices

### ✅ DO:
- Keep source code in git
- Ignore all build artifacts
- Use specific patterns over wildcards
- Document ignore rules
- Test .gitignore with `git check-ignore`

### ❌ DON'T:
- Commit executable files
- Ignore source code
- Use overly broad patterns
- Commit sensitive data
- Forget to update .gitignore

## 🚀 Distribution Strategy

### For Development
```bash
git clone <repo>
./build-complete.bat    # Generate local binaries
```

### For Users
```bash
git clone <repo>  # Get source
./install.bat        # Professional install
```

### For Releases
```bash
# Build clean distribution
./build-complete.bat
# Compress dist/ for release
tar -czf bed-tab-panel-v1.0.tar.gz dist/
```

---

*This strategy ensures small repository size while maintaining full functionality.*