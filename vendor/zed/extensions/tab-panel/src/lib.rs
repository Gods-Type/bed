use zed_extension_api::{self as zed, register_extension};

struct TabPanelExtension;

impl zed::Extension for TabPanelExtension {
    fn new() -> Self
    where
        Self: Sized,
    {
        Self
    }
}

register_extension!(TabPanelExtension);
