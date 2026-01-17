use gpui::{
    Action, AnyElement, App, Context, Div, Entity, EventEmitter, FocusHandle, Focusable,
    InteractiveElement, IntoElement, Pixels, Point, Render, SharedString, Stateful, Styled,
    UniformListScrollHandle, WeakEntity, Window, div, px,
};
use serde::{Deserialize, Serialize};
use ui::{IconButton, prelude::*};
use workspace::{
    Workspace,
    dock::{DockPosition, Panel, PanelEvent},
};

actions!(
    tab_panel,
    [
        /// Toggles focus on the tab panel.
        ToggleFocus,
    ]
);

const TAB_PANEL_KEY: &str = "TabPanel";

pub struct TabPanel {
    workspace: WeakEntity<Workspace>,
    focus_handle: FocusHandle,
}

impl TabPanel {
    pub fn new(
        workspace: &mut Workspace,
        window: &mut Window,
        cx: &mut Context<Workspace>,
    ) -> Entity<Self> {
        let focus_handle = cx.focus_handle();
        let workspace = workspace.weak_self();
        
        let tab_panel = cx.new(|_| Self {
            workspace,
            focus_handle,
        });
        
        tab_panel
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
                        IconButton::new("info", ui::IconName::Info)
                            .icon_size(ui::IconSize::Small)
                    )
            )
            .child(
                div()
                    .id("tab-panel-content")
                    .flex_1()
                    .items_center()
                    .justify_center()
                    .child(
                        div()
                            .px_4()
                            .py_8()
                            .text_center()
                            .child(
                                div()
                                    .text_sm()
                                    .text_color(cx.theme().colors().text_muted)
                                    .child("🚀 Tab Panel is ready!")
                            )
                            .child(
                                div()
                                    .text_xs()
                                    .text_color(cx.theme().colors().text_muted)
                                    .mt_2()
                                    .child("Use View → Tab Panel to toggle")
                            )
                    )
            )
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
        Some(ui::IconName::File)
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
    cx.observe_new(|workspace: &mut Workspace, _window, _cx| {
        // Simple initialization - no actions needed for basic functionality
    })
    .detach();
}