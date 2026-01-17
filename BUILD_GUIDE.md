# BED with Tab Panel - Build & Installation Guide

## 🚀 Quick Start

**For immediate installation, run:**
```bash
build-quick.bat
```

**For full compilation (10-20 minutes), run:**
```bash
build-complete.bat
```

## 📋 What You Get

BED with Tab Panel is a custom build of Zed editor that adds a new **Tab Panel** feature for managing open tabs in a hierarchical view.

### ✅ Features Included:
- **All standard Zed editor features**
- **New Tab Panel** for managing open tabs
- **View menu integration** (View → Tab Panel)
- **Command palette support** (search "Tab Panel")
- **Panel positioning** beside Project Panel
- **Professional installation** with shortcuts and PATH integration

### 🔄 Coming Soon:
- Search functionality within Tab Panel
- Right-click context menus
- Ctrl-Shift-T keyboard shortcuts
- Tab grouping and organization

## 🛠️ Build Options

### Option 1: Quick Demo (Recommended)
```bash
build-quick.bat
```
- ✅ Fast setup (1-2 minutes)
- ✅ Creates demo launcher
- ✅ Downloads official Zed if needed
- ❌ No Tab Panel integration (demo only)

### Option 2: Full Build
```bash
build-complete.bat
```
- ✅ Complete Tab Panel integration
- ✅ Custom compiled executable
- ✅ Professional installer
- ⏱️ Takes 10-20 minutes

### Option 3: Manual Build
```bash
cd vendor/zed
cargo build --release --bin zed
```

## 📦 Output Files

After successful build, you'll find these files in the `dist/` folder:

```
dist/
├── bed-with-tab-panel.exe    # Main executable
├── install.bat               # Windows installer
├── README.txt               # Documentation
├── resources/               # Editor resources
└── portable/                # Portable version
    └── bed-with-tab-panel.exe
```

## 💻 Installation Methods

### Method 1: Automatic Installation (Recommended)
1. Run `dist\install.bat`
2. Follow the installer prompts
3. Launch from desktop shortcut or Start Menu

### Method 2: Portable Version
1. Go to `dist\portable\`
2. Run `bed-with-tab-panel.exe` directly
3. No installation required

### Method 3: Direct Execution
1. Run `dist\bed-with-tab-panel.exe`
2. No installation, works immediately

## 🎯 Using Tab Panel

### To Open Tab Panel:
- **Menu**: `View → Tab Panel`
- **Command Palette**: Search for "Tab Panel"
- **Coming Soon**: `Ctrl+Shift+T`

### Tab Panel Features:
- **Hierarchical view** of open tabs
- **Easy navigation** between projects
- **Integration** with existing workflow
- **Searchable** (coming soon)
- **Context menus** (coming soon)

## 🔧 System Requirements

- **Windows 10** or later
- **2GB RAM** minimum
- **500MB** disk space
- **Rust toolchain** (for building only)

## 🛠️ Troubleshooting

### Build Issues:
1. **Rust not found**: Install from https://rustup.rs/
2. **Build fails**: Run `cargo update` first
3. **Permission errors**: Run as Administrator
4. **Antivirus blocking**: Add exception for build folder

### Runtime Issues:
1. **Tab Panel missing**: Check View menu
2. **Crashes on startup**: Run as Administrator
3. **No themes/themes missing**: Check resources folder

### Performance Issues:
1. **Slow startup**: Disable antivirus scanning
2. **High memory usage**: Close other applications
3. **Lag on large projects**: Increase RAM allocation

## 📁 Project Structure

```
bed/
├── vendor/zed/                    # Zed source code
│   └── crates/tab_panel/          # Our Tab Panel module
├── build-quick.bat                # Quick demo builder
├── build-complete.bat             # Full build script
├── dist/                         # Build output
└── README.md                     # This file
```

## 🔄 Development

### Adding New Features:
1. Edit `vendor/zed/crates/tab_panel/src/tab_panel.rs`
2. Run `build-complete.bat`
3. Test with `dist\bed-with-tab-panel.exe`

### Code Structure:
- **Tab Panel**: Main UI component
- **Actions**: Command palette integration
- **Panel**: Dock system integration
- **Events**: User interaction handling

## 📝 Build Process Details

### What the Build Script Does:
1. **Environment check**: Verifies Rust and dependencies
2. **Clean build**: Removes previous builds
3. **Dependency update**: Ensures latest crates
4. **Compilation**: Builds Zed with Tab Panel
5. **Packaging**: Creates distributable files
6. **Installer**: Generates Windows installer

### Build Times:
- **First build**: 15-20 minutes (dependency download)
- **Subsequent builds**: 5-10 minutes
- **Quick build**: 1-2 minutes (demo only)

## 🎉 Getting Help

### Resources:
- **Documentation**: `dist\README.txt`
- **Source code**: `vendor/zed/crates/tab_panel/`
- **Zed docs**: https://zed.dev/docs
- **Rust docs**: https://doc.rust-lang.org/

### Common Issues:
1. **"zed.exe not found"**: Run build-complete.bat
2. **"Tab Panel not in menu"**: Restart the application
3. **"Build fails"**: Check Rust installation
4. **"Installer fails"**: Run as Administrator

## 🚀 Next Steps

After installation:
1. **Launch BED with Tab Panel**
2. **Open the View menu**
3. **Select "Tab Panel"**
4. **Enjoy enhanced tab management!**

---

**BED with Tab Panel** - Enhanced Zed Editor Experience  
Build Date: %date%  
Version: 1.0  
Based on: Zed Editor (%ZED_VERSION%)