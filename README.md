# BED - Tab Panel Extension for Zed

BED (Better Editor Development) adds enhanced tab management to the Zed editor through a Tab Panel extension.

## 🚀 Quick Start

### Option 1: Standard Build (Recommended)
```bash
# Clone the repository
git clone https://github.com/your-repo/bed.git
cd bed

# Build with our helper script
build-helper.bat
```

### Option 2: Safe Build (No Compilation)
```bash
# Install Zed from https://zed.dev
# Then run:
build-helper.bat
# Choose option 2 (Safe Build)
```

## 📋 Features

- **Tab Panel**: View and manage all open tabs in a dedicated panel
- **Quick Navigation**: Easily switch between tabs with keyboard or mouse
- **Search Functionality**: Find tabs quickly with search
- **Visual Indicators**: See modified tabs at a glance
- **Keyboard Shortcuts**: Toggle panel with Ctrl+Shift+T

## 🛠️ Build Issues & Solutions

### Common Problem: AWS-LC-SYS Compilation Errors

The build may fail with `aws-lc-sys` compilation errors on Windows. We provide solutions:

1. **Use Build Helper** (Recommended):
   ```bash
   build-helper.bat
   # Choose option 1 for automatic fixes
   ```

2. **Manual Fix**:
   ```bash
   set AWS_LC_SYS_STATIC=1
   set AWS_LC_SYS_C_STD=c11
   set RUSTFLAGS=-C target-feature=+crt-static
   ```

3. **Safe Build** (No Compilation):
   ```bash
   build-helper.bat
   # Choose option 2 to use existing Zed installation
   ```

## 📁 Project Structure

```
bed/
├── extension/          # Main Tab Panel extension
├── vendor/zed/         # Zed source code
├── dist/               # Build output
├── build.bat           # Main build script
├── build-helper.bat    # Build troubleshooting helper
└── README.md           # This file
```

## 🔧 Development

### Building the Extension

```bash
cd extension
cargo build
```

### Running Tests

```bash
cd extension
cargo test
```

## 🎯 Usage

After installation:

1. **Toggle Tab Panel**: View → Tab Panel or Ctrl+Shift+T
2. **Search Tabs**: Click the search button in the panel
3. **Switch Tabs**: Click on any tab in the panel
4. **Keyboard Navigation**: Use arrow keys when panel is focused

## 📋 Roadmap

- [x] Basic Tab Panel implementation
- [x] Tab listing and navigation
- [ ] Advanced search and filtering
- [ ] Right-click context menu
- [ ] Tab grouping and organization
- [ ] Customizable appearance

## 🤝 Contributing

Contributions are welcome! Please open issues and pull requests on GitHub.

## 📜 License

This project is licensed under the MIT License. See LICENSE for details.

## 📞 Support

For help and discussions:
- GitHub Issues: [https://github.com/your-repo/bed/issues](https://github.com/your-repo/bed/issues)
- GitHub Discussions: [https://github.com/your-repo/bed/discussions](https://github.com/your-repo/bed/discussions)