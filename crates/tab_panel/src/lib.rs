use anyhow::Context as _;
use collections::{BTreeSet, HashMap, HashSet, hash_map};
use db::kvp::KEY_VALUE_STORE;
use editor::{
    AnchorRangeExt, Bias, DisplayPoint, Editor, EditorEvent, ExcerptId, ExcerptRange,
    MultiBufferSnapshot, RangeToAnchorExt, SelectionEffects,
    display_map::ToDisplayPoint,
    items::{entry_git_aware_label_color, entry_label_color},
    scroll::{Autoscroll, ScrollAnchor},
};
use file_icons::FileIcons;
use fuzzy::{StringMatch, StringMatchCandidate, match_strings};
use gpui::{
    Action, AnyElement, App, AppContext as _, AsyncWindowContext, Bounds, ClipboardItem, Context,
    DismissEvent, Div, ElementId, Entity, EventEmitter, FocusHandle, Focusable, HighlightStyle,
    InteractiveElement, IntoElement, KeyContext, ListHorizontalSizingBehavior, ListSizingBehavior,
    MouseButton, MouseDownEvent, ParentElement, Pixels, Point, Render, ScrollStrategy,
    SharedString, Stateful, StatefulInteractiveElement as _, Styled, Subscription, Task,
    UniformListScrollHandle, WeakEntity, Window, actions, anchored, deferred, div, point, px, size,
    uniform_list,
};
use itertools::Itertools;
use language::{Anchor, BufferId, BufferSnapshot, OffsetRangeExt, OutlineItem};
use menu::{Cancel, SelectFirst, SelectLast, SelectNext, SelectPrevious};
use project::{File, Fs, GitEntry, GitTraversal, Project, ProjectItem};
use search::{BufferSearchBar, ProjectSearchView};
use serde::{Deserialize, Serialize};
use settings::{Settings, SettingsStore};
use smol::channel;
use theme::{SyntaxTheme, ThemeSettings};
use ui::{
    ContextMenu, FluentBuilder, HighlightedLabel, IconButton, IconButtonShape, IndentGuideColors,
    IndentGuideLayout, ListItem, ScrollAxes, Scrollbars, Tab, Tooltip, WithScrollbar, prelude::*,
};
use util::{RangeExt, ResultExt, TryFutureExt, debug_panic, rel_path::RelPath};
use workspace::{
    OpenInTerminal, WeakItemHandle, Workspace,
    dock::{DockPosition, Panel, PanelEvent},
    item::ItemHandle,
    searchable::{SearchEvent, SearchableItem},
};
use worktree::{Entry, ProjectEntryId, WorktreeId};

actions!(
    tab_panel,
    [
        /// Opens the selected entry in the editor.
        OpenSelectedEntry,
        /// Reveals the selected item in the system file manager.
        RevealInFileManager,
        /// Scroll half a page upwards
        ScrollUp,
        /// Scroll half a page downwards
        ScrollDown,
        /// Scroll until the cursor displays at the center
        ScrollCursorCenter,
        /// Scroll until the cursor displays at the top
        ScrollCursorTop,
        /// Scroll until the cursor displays at the bottom
        ScrollCursorBottom,
        /// Selects the parent of the current entry.
        SelectParent,
        /// Toggles the pin status of the active editor.
        ToggleActiveEditorPin,
        /// Toggles focus on the tab panel.
        ToggleFocus,
    ]
);

const TAB_PANEL_KEY: &str = "TabPanel";
const UPDATE_DEBOUNCE: std::time::Duration = std::time::Duration::from_millis(50);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EntryKind {
    Tab,
    Group,
    Space,
    Window,
}

#[derive(Debug, Clone)]
pub struct TabEntry {
    pub id: ProjectEntryId,
    pub kind: EntryKind,
    pub name: SharedString,
    pub path: Option<Arc<RelPath>>,
    pub children: Vec<TabEntry>,
    pub is_open: bool,
    pub is_pinned: bool,
    pub is_muted: bool,
}

pub struct TabPanel {
    workspace: WeakEntity<Workspace>,
    focus_handle: FocusHandle,
    entries: Vec<TabEntry>,
    selection: Option<ProjectEntryId>,
    expanded_entries: HashSet<ProjectEntryId>,
    scroll_handle: UniformListScrollHandle,
    search_editor: Option<Entity<Editor>>,
    search_matches: Vec<StringMatch>,
    pending_update: Option<Task<()>>,
}

impl TabPanel {
    pub fn new(
        workspace: &mut Workspace,
        window: &mut Window,
        cx: &mut Context<Workspace>,
    ) -> Entity<Self> {
        let focus_handle = cx.focus_handle();
        let workspace = workspace.weak_self();
        
        cx.on_focus(&focus_handle, window, Self::focus_in).detach();
        
        let tab_panel = cx.new(|cx| {
            let mut panel = Self {
                workspace,
                focus_handle,
                entries: Vec::new(),
                selection: None,
                expanded_entries: HashSet::new(),
                scroll_handle: UniformListScrollHandle::new(),
                search_editor: None,
                search_matches: Vec::new(),
                pending_update: None,
            };
            
            panel.refresh_entries(cx);
            panel
        });
        
        tab_panel
    }
    
    fn refresh_entries(&mut self, cx: &mut Context<Self>) {
        // TODO: Implement tab entry collection from workspace
        // This will need to integrate with the workspace's tab management system
        self.entries = vec![
            TabEntry {
                id: ProjectEntryId::from(1),
                kind: EntryKind::Tab,
                name: "Example Tab".into(),
                path: None,
                children: Vec::new(),
                is_open: true,
                is_pinned: false,
                is_muted: false,
            }
        ];
        cx.notify();
    }
    
    fn focus_in(&mut self, window: &mut Window, cx: &mut Context<Self>) {
        // TODO: Handle focus in events
    }
    
    fn open_selected_entry(&mut self, window: &mut Window, cx: &mut Context<Self>) {
        if let Some(entry_id) = self.selection {
            // TODO: Implement opening the selected entry
        }
    }
    
    fn select_entry(&mut self, entry_id: ProjectEntryId, window: &mut Window, cx: &mut Context<Self>) {
        self.selection = Some(entry_id);
        cx.notify();
    }
    
    fn toggle_expanded(&mut self, entry_id: ProjectEntryId, cx: &mut Context<Self>) {
        if self.expanded_entries.contains(&entry_id) {
            self.expanded_entries.remove(&entry_id);
        } else {
            self.expanded_entries.insert(entry_id);
        }
        cx.notify();
    }
    
    fn update_search(&mut self, query: &str, window: &mut Window, cx: &mut Context<Self>) {
        if query.is_empty() {
            self.search_matches.clear();
        } else {
            // TODO: Implement search functionality
            self.search_matches.clear();
        }
        cx.notify();
    }
}

impl Render for TabPanel {
    fn render(&mut self, window: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .id("tab-panel")
            .size_full()
            .bg(cx.theme().colors().panel_background)
            .child(
                div()
                    .id("tab-panel-header")
                    .flex()
                    .items_center()
                    .justify_between()
                    .px_2()
                    .py_1()
                    .border_b_1()
                    .border_color(cx.theme().colors().border)
                    .child(
                        div()
                            .text_lg()
                            .font_weight(cx.theme().font().medium)
                            .text_color(cx.theme().colors().text_primary)
                            .child("Tab Panel")
                    )
                    .child(
                        div()
                            .flex()
                            .gap_2()
                            .child(
                                IconButton::new("search", ui::IconName::Search)
                                    .icon_size(ui::IconSize::Small)
                                    .on_click(cx.listener(|this, window, cx| {
                                        // TODO: Implement search functionality
                                    }))
                            )
                    )
            )
            .child(
                div()
                    .id("tab-panel-content")
                    .flex_1()
                    .overflow_y_scroll()
                    .scroll_handle(self.scroll_handle.clone())
                    .child(
                        uniform_list(
                            self::ListState::new(
                                self.entries.clone(),
                                self.selection,
                                &self.expanded_entries,
                                self.search_matches.clone(),
                            ),
                            "tab-panel-list",
                        )
                        .flex_1()
                    )
            )
    }
}

struct ListState {
    entries: Vec<TabEntry>,
    selection: Option<ProjectEntryId>,
    expanded_entries: HashSet<ProjectEntryId>,
    search_matches: Vec<StringMatch>,
}

impl ListState {
    fn new(
        entries: Vec<TabEntry>,
        selection: Option<ProjectEntryId>,
        expanded_entries: &HashSet<ProjectEntryId>,
        search_matches: Vec<StringMatch>,
    ) -> Self {
        Self {
            entries,
            selection,
            expanded_entries: expanded_entries.clone(),
            search_matches,
        }
    }
}

impl gpui::Listable for ListState {
    type Item = TabEntry;
    
    fn items(&self) -> &[Self::Item] {
        &self.entries
    }
    
    fn item_count(&self) -> usize {
        self.entries.len()
    }
    
    fn item_at(&self, index: usize) -> Option<&Self::Item> {
        self.entries.get(index)
    }
}

impl Panel for TabPanel {
    fn persistent_name() -> &'static str {
        TAB_PANEL_KEY
    }
    
    fn position(&self, window: &Window, cx: &App) -> DockPosition {
        DockPosition::Left
    }
    
    fn size(&self, window: &Window, cx: &App) -> Pixels {
        px(300.0)
    }
    
    fn set_size(&mut self, size: Option<Pixels>, window: &mut Window, cx: &mut Context<Self>) {
        // TODO: Implement size setting
    }
    
    fn icon(&self, window: &Window, cx: &App) -> Option<ui::IconName> {
        Some(ui::IconName::Tab)
    }
    
    fn icon_tooltip(&self, window: &Window, cx: &App) -> Option<&'static str> {
        Some("Tab Panel")
    }
    
    fn toggle_action(&self, window: &Window, cx: &App) -> Box<dyn Action> {
        Box::new(ToggleFocus)
    }
    
    fn icon_label(&self, window: &Window, cx: &App) -> Option<String> {
        Some("Tab Panel".to_string())
    }
    
    fn new(
        workspace: &mut Workspace,
        window: &mut Window,
        cx: &mut Context<Workspace>,
    ) -> Entity<Self> {
        Self::new(workspace, window, cx)
    }
}

impl EventEmitter<PanelEvent> for TabPanel {}

impl Focusable for TabPanel {
    fn focus_handle(&self, cx: &App) -> FocusHandle {
        self.focus_handle.clone()
    }
}

impl TabPanel {
    pub fn toggle_focus(workspace: &mut Workspace, window: &mut Window, cx: &mut Context<Workspace>) {
        workspace.toggle_panel_focus::<TabPanel>(window, cx);
    }
}

pub fn init(cx: &mut App) {
    workspace::register_serializable_item::<TabPanel>(cx);
    
    cx.observe_new(|workspace: &mut Workspace, _window, _cx| {
        workspace.register_action(TabPanel::deploy);
    })
    .detach();
}