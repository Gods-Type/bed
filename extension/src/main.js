// BED Tab Panel Extension for Zed
// Provides enhanced tab management and navigation

import * as zed from "zed";

export function activate() {
  console.log("BED Tab Panel extension activated");
  
  // Register the Tab Panel
  zed.registerPaneItem({
    name: "Tab Panel",
    icon: "tab",
    defaultLocation: "left",
    createPaneItem: () => new TabPanel()
  });

  // Register commands
  zed.registerCommand({
    id: "bed-tab-panel.toggle",
    title: "Toggle Tab Panel",
    callback: () => {
      zed.togglePane("Tab Panel");
    }
  });

  zed.registerCommand({
    id: "bed-tab-panel.focus",
    title: "Focus Tab Panel",
    callback: () => {
      zed.activatePane("Tab Panel");
    }
  });

  // Add menu items
  zed.updateMenu([
    {
      menu: "View",
      items: [
        { type: "separator" },
        {
          label: "Tab Panel",
          command: "bed-tab-panel.toggle"
        }
      ]
    }
  ]);
}

export function deactivate() {
  console.log("BED Tab Panel extension deactivated");
}

class TabPanel {
  constructor() {
    this.element = null;
    this.tabs = [];
  }

  getTitle() {
    return "Tab Panel";
  }

  getIcon() {
    return "tab";
  }

  getElement() {
    if (!this.element) {
      this.createElement();
    }
    return this.element;
  }

  createElement() {
    this.element = document.createElement("div");
    this.element.className = "bed-tab-panel";
    
    // Header
    const header = document.createElement("div");
    header.className = "bed-tab-panel-header";
    header.innerHTML = `
      <div class="bed-tab-panel-title">
        <span class="bed-tab-panel-icon">📋</span>
        <span>Tab Panel</span>
      </div>
      <div class="bed-tab-panel-actions">
        <button class="bed-tab-panel-search" title="Search tabs">🔍</button>
      </div>
    `;
    
    // Content
    const content = document.createElement("div");
    content.className = "bed-tab-panel-content";
    content.id = "bed-tab-panel-content";
    
    // Info message
    const info = document.createElement("div");
    info.className = "bed-tab-panel-info";
    info.innerHTML = `
      <div class="bed-tab-panel-welcome">
        <h3>🚀 Tab Panel</h3>
        <p>Enhanced tab management for Zed</p>
        <div class="bed-tab-panel-features">
          <ul>
            <li>✅ View all open tabs</li>
            <li>✅ Quick navigation</li>
            <li>✅ Search tabs (coming soon)</li>
            <li>✅ Right-click actions (coming soon)</li>
          </ul>
        </div>
        <div class="bed-tab-panel-shortcuts">
          <strong>Keyboard Shortcuts:</strong><br>
          <kbd>Ctrl+Shift+T</kbd> - Toggle Tab Panel (coming soon)<br>
          <kbd>Ctrl+Shift+P</kbd> - Search "Tab Panel"
        </div>
      </div>
    `;
    
    content.appendChild(info);
    
    // Search bar (hidden for now)
    const search = document.createElement("div");
    search.className = "bed-tab-panel-search-container";
    search.style.display = "none";
    search.innerHTML = `
      <input type="text" placeholder="Search tabs..." class="bed-tab-panel-search-input">
    `;
    
    this.element.appendChild(header);
    this.element.appendChild(search);
    this.element.appendChild(content);
    
    // Add event listeners
    this.addEventListeners();
    
    // Start monitoring tabs
    this.startTabMonitoring();
  }

  addEventListeners() {
    const searchBtn = this.element.querySelector(".bed-tab-panel-search");
    const searchContainer = this.element.querySelector(".bed-tab-panel-search-container");
    const searchInput = this.element.querySelector(".bed-tab-panel-search-input");
    
    searchBtn.addEventListener("click", () => {
      const isVisible = searchContainer.style.display !== "none";
      searchContainer.style.display = isVisible ? "none" : "block";
      if (!isVisible) {
        searchInput.focus();
      }
    });
    
    searchInput.addEventListener("input", (e) => {
      this.filterTabs(e.target.value);
    });
    
    searchInput.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        searchContainer.style.display = "none";
        searchInput.value = "";
        this.filterTabs("");
      }
    });
  }

  startTabMonitoring() {
    // Monitor for tab changes
    setInterval(() => {
      this.updateTabList();
    }, 1000);
    
    this.updateTabList();
  }

  async updateTabList() {
    try {
      // Get current tabs (this is a simplified implementation)
      const tabs = await this.getCurrentTabs();
      
      if (JSON.stringify(tabs) !== JSON.stringify(this.tabs)) {
        this.tabs = tabs;
        this.renderTabs();
      }
    } catch (error) {
      console.error("Error updating tab list:", error);
    }
  }

  async getCurrentTabs() {
    // This is a placeholder implementation
    // In a real extension, you'd use Zed's API to get actual tabs
    return [
      {
        id: 1,
        title: "README.md",
        path: "/workspace/README.md",
        active: true,
        modified: false
      }
    ];
  }

  renderTabs() {
    const content = this.element.querySelector("#bed-tab-panel-content");
    
    if (this.tabs.length === 0) {
      content.innerHTML = `
        <div class="bed-tab-panel-empty">
          <p>No tabs open</p>
        </div>
      `;
      return;
    }

    const tabsHtml = this.tabs.map(tab => `
      <div class="bed-tab-panel-tab ${tab.active ? 'active' : ''}" 
           data-tab-id="${tab.id}">
        <div class="bed-tab-panel-tab-icon">📄</div>
        <div class="bed-tab-panel-tab-info">
          <div class="bed-tab-panel-tab-title">${tab.title}</div>
          <div class="bed-tab-panel-tab-path">${tab.path}</div>
        </div>
        ${tab.modified ? '<div class="bed-tab-panel-tab-modified">●</div>' : ''}
      </div>
    `).join("");

    content.innerHTML = `
      <div class="bed-tab-panel-tabs">
        ${tabsHtml}
      </div>
    `;

    // Add click handlers
    content.querySelectorAll(".bed-tab-panel-tab").forEach(tabEl => {
      tabEl.addEventListener("click", () => {
        const tabId = parseInt(tabEl.dataset.tabId);
        this.activateTab(tabId);
      });
    });
  }

  filterTabs(query) {
    // Implementation for filtering tabs
    console.log("Filtering tabs:", query);
  }

  activateTab(tabId) {
    console.log("Activating tab:", tabId);
    // Implementation for activating a tab
  }

  onDidDestroy() {
    // Cleanup
    console.log("Tab Panel destroyed");
  }
}