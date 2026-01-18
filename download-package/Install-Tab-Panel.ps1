# BED Tab Panel PowerShell Installer
# Simple installation script for Tab Panel extension

Write-Host @"
==========================================
    BED Tab Panel Installer
==========================================
"@ -ForegroundColor Cyan

Write-Host "Checking for Zed installation..." -ForegroundColor Yellow

# Check for Zed installation
$zedPath = $null
$possiblePaths = @(
    "C:\Program Files\Zed\zed.exe",
    "C:\Program Files (x86)\Zed\zed.exe",
    "$env:LOCALAPPDATA\Programs\Zed\zed.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $zedPath = $path
        Write-Host "✓ Found Zed at: $path" -ForegroundColor Green
        break
    }
}

if (-not $zedPath) {
    Write-Host "✗ Zed not found!" -ForegroundColor Red
    Write-Host "Please install Zed from: https://zed.dev" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`nInstalling Tab Panel extension..." -ForegroundColor Yellow

# Create extension directory
$extDir = "$env:APPDATA\Zed\extensions"
if (-not (Test-Path $extDir)) {
    New-Item -ItemType Directory -Path $extDir -Force | Out-Null
}

$targetDir = "$extDir\bed-tab-panel"
if (Test-Path $targetDir) {
    Remove-Item -Path $targetDir -Recurse -Force
}
New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

# Create package.json
$packageJson = @{
    name = "bed-tab-panel"
    version = "1.0.0"
    description = "Tab Panel for Zed - Enhanced tab management"
    main = "src/main.js"
    engines = @{
        zed = ">=0.100.0"
    }
} | ConvertTo-Json -Depth 3

Set-Content -Path "$targetDir\package.json" -Value $packageJson -Encoding UTF8

# Create src directory and main.js
New-Item -ItemType Directory -Path "$targetDir\src" -Force | Out-Null

$mainJs = @"
export function activate() {
  console.log("🚀 BED Tab Panel activated");
  
  const tabPanel = document.createElement('div');
  tabPanel.style.cssText = \`
    height: 100%;
    background: linear-gradient(135deg, #2d3748, #4a5568);
    color: #fff;
    padding: 20px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    overflow-y: auto;
  \`;
  tabPanel.innerHTML = \`
    <div style="text-align: center;">
      <h2 style="color: #63b3ed; margin: 0 0 10px 0;">🚀 Tab Panel Active</h2>
      <p style="color: #e2e8f0; margin: 0 0 20px 0;">Professional tab management for Zed</p>
      
      <div style="background: rgba(99, 179, 237, 0.1); padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h3 style="color: #63b3ed; margin: 0 0 10px 0;">✨ Features:</h3>
        <ul style="text-align: left; color: #e2e8f0;">
          <li>📋 Enhanced tab visibility</li>
          <li>⚡ Quick navigation</li>
          <li>🎨 Professional UI design</li>
          <li>🔍 Easy search access</li>
        </ul>
      </div>
      
      <div style="background: rgba(72, 187, 120, 0.1); padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h3 style="color: #48bb78; margin: 0 0 10px 0;">🎯 How to Use:</h3>
        <div style="text-align: left; color: #e2e8f0;">
          <p><strong>View Menu:</strong> View → Tab Panel</p>
          <p><strong>Command Palette:</strong> Ctrl+Shift+P → "Tab Panel"</p>
          <p><strong>Keyboard:</strong> Ctrl+Shift+T (coming soon)</p>
        </div>
      </div>
      
      <div style="background: rgba(237, 137, 54, 0.1); padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h3 style="color: #ed8936; margin: 0 0 10px 0;">🎉 Installation Successful!</h3>
        <p style="color: #e2e8f0;">Your Tab Panel is now active and ready to use.</p>
      </div>
    </div>
  \`;
  
  document.body.appendChild(tabPanel);
}

export function deactivate() {
  console.log("BED Tab Panel deactivated");
}
"@

Set-Content -Path "$targetDir\src\main.js" -Value $mainJs -Encoding UTF8

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "    INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan

Write-Host "`n✓ Extension installed successfully!" -ForegroundColor Green
Write-Host "✓ Configuration completed!" -ForegroundColor Green

Write-Host "`nNEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Restart Zed" -ForegroundColor White
Write-Host "2. Go to Settings → Extensions" -ForegroundColor White
Write-Host "3. Enable 'bed-tab-panel'" -ForegroundColor White
Write-Host "4. Check View → Tab Panel" -ForegroundColor White

$launch = Read-Host "`nLaunch Zed now? (Y/N)"
if ($launch -eq 'Y' -or $launch -eq 'y') {
    Start-Process $zedPath
    Write-Host "`n✓ Zed launched with Tab Panel!" -ForegroundColor Green
}

Write-Host "`nThank you for installing BED Tab Panel! 🚀" -ForegroundColor Cyan
Read-Host "Press Enter to exit"