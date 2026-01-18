# BED Tab Panel Extension

A Tab Panel extension for Zed editor that provides enhanced tab management and navigation.

## Features

- 📋 **Tab Panel** - Shows all open tabs in a dedicated panel
- 🎯 **Quick Navigation** - Click any tab to switch to it
- 🔍 **Search** - Filter tabs by name (basic implementation)
- 🎨 **Theme Support** - Works with light and dark themes
- ⌨️ **Command Palette** - Search "Tab Panel" to toggle
- 📍 **Menu Integration** - Access via View → Tab Panel

## Installation

1. Clone this repository
2. Open Zed
3. Go to Settings → Extensions
4. Click "Install Extension" and select this directory
5. Enable "bed-tab-panel" in extensions list

## Usage

### Access Methods

1. **Menu Bar**: `View → Tab Panel`
2. **Command Palette**: `Ctrl+Shift+P` → Search "Tab Panel"
3. **Panel Toggle**: Click the panel icon in the left dock

### Features

- **Tab List**: See all open tabs with file names and paths
- **Active Tab Highlight**: Current tab is highlighted
- **Modified Indicator**: Shows dots for modified tabs
- **Search**: Filter tabs by typing in the search box
- **Hover Effects**: Visual feedback on mouse hover

## Development

This extension is part of the BED (Browser-Enhanced Development) project.

### Structure

```
extension/
├── package.json          # Extension manifest
├── src/main.js          # Main extension code
├── styles.css           # Panel styling
└── README.md            # This file
```

### Building

The extension works as-is with Zed's extension system. No build step required.

## Contributing

1. Fork the repository
2. Make your changes
3. Test with Zed
4. Submit a pull request

## License

MIT License - see LICENSE file for details.

## Roadmap

- [ ] Real tab integration with Zed's tab API
- [ ] Drag and drop tab reordering
- [ ] Right-click context menus
- [ ] Tab groups and organization
- [ ] Cross-workspace tab management
- [ ] Keyboard shortcuts
- [ ] Tab history navigation
- [ ] Split tab support

## Troubleshooting

If the Tab Panel doesn't appear:

1. Ensure the extension is enabled in Settings → Extensions
2. Check that "bed-tab-panel" is listed and enabled
3. Restart Zed if needed
4. Check the developer console for errors

For issues, please report them on the GitHub repository.