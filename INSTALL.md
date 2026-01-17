# 🚀 BED with Tab Panel - Installation Quick Reference

## ⚡ FASTEST WAY TO GET STARTED (2 minutes)

### 1️⃣ Download & Build
```bash
git clone https://github.com/your-repo/bed.git
cd bed
build-quick.bat
```

### 2️⃣ Run the Application
```bash
dist\bed-with-tab-panel.bat
```

---

## 🏗️ COMPLETE INSTALLATION (15 minutes)

### 1️⃣ Full Build
```bash
git clone https://github.com/your-repo/bed.git
cd bed
build-complete.bat
```

### 2️⃣ Install
```bash
dist\install.bat
```

### 3️⃣ Launch
- **Desktop**: "BED with Tab Panel" shortcut
- **Start Menu**: Programs → BED → BED with Tab Panel
- **Command Line**: `bed-with-tab-panel`

---

## 📁 WHERE FILES ARE LOCATED

After successful build, find everything in the `dist/` folder:

```
bed/
└── dist/                              # 🎯 ALL FILES HERE
    ├── 💻 bed-with-tab-panel.exe       # MAIN PROGRAM
    ├── 📀 install.bat                  # INSTALLER
    ├── 📖 README.txt                   # INSTRUCTIONS  
    ├── 📁 resources/                  # PROGRAM ASSETS
    └── 📁 portable/                    # PORTABLE VERSION
        └── 💻 bed-with-tab-panel.exe
```

---

## 🎯 HOW TO USE TAB PANEL

### 📍 Open Tab Panel:
- **Menu**: `View → Tab Panel`
- **Command Palette**: `Ctrl+Shift+P` → type "Tab Panel"
- **Coming Soon**: `Ctrl+Shift+T`

### ✨ What Tab Panel Does:
- 📋 Shows all open tabs in organized view
- 🎯 Highlights currently active tab
- 🔄 Updates automatically when tabs change
- 📍 Positioned beside Project Panel
- 🎨 Matches Zed's visual design

---

## 🔧 TROUBLESHOOTING

### ❌ Build Issues:
1. **"Rust not found"** → Install from https://rustup.rs/
2. **"Build fails"** → Run as Administrator
3. **"Permission denied"** → Disable antivirus temporarily

### ❌ Runtime Issues:  
1. **"Tab Panel not showing"** → Check View menu
2. **"Crashes on startup"** → Run as Administrator
3. **"Missing features"** → Re-run build-complete.bat

---

## 📞 GET HELP

- **📖 Documentation**: `dist\README.txt`
- **🐛 Report Issues**: https://github.com/your-repo/bed/issues
- **💬 Community**: https://github.com/your-repo/bed/discussions

---

## ✅ SUCCESS CHECKLIST

You're done when you can:
- [ ] ✅ Run `build-quick.bat` or `build-complete.bat`
- [ ] ✅ See files in `dist/` folder  
- [ ] ✅ Launch BED with Tab Panel
- [ ] ✅ Find "Tab Panel" in View menu
- [ ] ✅ Toggle Tab Panel on/off
- [ ] ✅ See Tab Panel beside Project Panel

**🎉 Congratulations! You now have BED with Tab Panel installed!**

---

*Created: $(date)*  
*Version: 1.0.0*  
*Status: ✅ Ready for Production*