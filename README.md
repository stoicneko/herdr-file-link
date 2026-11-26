# herdr-file-link

A [herdr](https://herdr.dev) plugin for Windows that opens `file://` links on **Ctrl+click** while herdr's mouse capture is on.

## Why

With `ui.mouse_capture = true` (the default), herdr handles Ctrl+click on links itself instead of passing them to the outer terminal. Its built-in opener only opens `http://` and `https://` links; `file://` links (for example the file paths that coding agents print as OSC 8 hyperlinks) do nothing unless a plugin handles them ([herdr#5608](https://github.com/herdrdev/herdr/issues/5608)).

This plugin registers a link handler for `^file://`. On Ctrl+click it converts the URL to a local path and opens it with the Windows default app (`Invoke-Item`); folders open in Explorer.

So you can keep mouse capture on (wheel scrollback, clickable tabs and panes) and still Ctrl+click file links.

## Install

```powershell
herdr plugin install stoicneko/herdr-file-link
```

Or from a local checkout:

```powershell
herdr plugin link path\to\herdr-file-link
```

Requirements: herdr 0.9.4 or later, Windows, PowerShell 7 (`pwsh.exe`) on `PATH`.

## Behavior

- Only local `file://` URLs are handled. Percent-encoding is decoded and any `#fragment` is dropped.
- If the path does not exist, nothing is opened.
- Each attempt is logged to `open.log` in the plugin's state directory (`HERDR_PLUGIN_STATE_DIR`).

## Known limitation

herdr does not draw its Ctrl-hover underline for `file://` links, so there is no hover hint. Clicking still works.

## License

MIT
