# D3Macro

[![AppImage Build](https://github.com/vickwv/D3Macro/actions/workflows/build-appimage.yml/badge.svg)](https://github.com/vickwv/D3Macro/actions/workflows/build-appimage.yml)
[![Windows Build](https://github.com/vickwv/D3Macro/actions/workflows/build-windows.yml/badge.svg)](https://github.com/vickwv/D3Macro/actions/workflows/build-windows.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

**Language:** English | [简体中文](./README.zh-CN.md)

Cross-platform combat automation toolkit for **Diablo III**, featuring native Linux Wayland support, visual detection, and configurable skill rotation profiles.

D3Macro is a desktop automation helper for Diablo III players who want reliable cross-platform combat automation without invasive game modification.

It combines configurable combat macros, visual state detection, platform-aware input and capture backends, and a modern Qt desktop interface in a single lightweight application.

Unlike a simple keyboard repeater, D3Macro includes game window detection, screenshot-based recognition, inventory-safe slot handling, and Linux KDE Wayland compatibility.

## Why D3Macro

Traditional macro tools usually stop at key repetition.

D3Macro extends that with:

- game window awareness
- visual state detection
- platform-aware input handling
- Linux Wayland compatibility
- configurable combat profiles
- integrated Qt desktop GUI

This makes automation behavior more reliable across desktop environments and Diablo III gameplay scenarios.

## Combat Automation

- Configurable skill rotation profiles
- Timed, repeated, and hold-based skill actions
- Profile hotkeys and runtime profile switching
- Global start / stop hotkeys and quick pause actions
- GUI launcher and terminal runner modes

## Visual Detection

- Active window matching for Diablo III sessions
- Screenshot-based detection for inventory, stash, gamble, and Kanai's Cube states
- Safezone slot mapping for protected inventory positions
- Platform-aware capture backends for X11, KDE Wayland, and Windows desktop sessions

## Cross-platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Linux X11 / XWayland | ✅ Recommended | Most complete and straightforward setup |
| KDE Wayland | ✅ Supported | KWin window queries plus Spectacle-based capture |
| Windows | ✅ Supported | Native foreground-window detection via ctypes |

D3Macro's most distinctive platform feature is Linux game automation on modern desktops, especially KDE Wayland where traditional hook-heavy macro tools are often unreliable.

## Screenshots

### Main Control Window

![Main Window](./mainwindow.png)

### Safezone Slot Detection

![Safezone](./safezone.png)

## Quick Start

### Linux

Download the latest AppImage from [Releases](https://github.com/vickwv/D3Macro/releases/latest):

```bash
chmod +x D3Macro-Linux-x86_64.AppImage
./D3Macro-Linux-x86_64.AppImage
```

### Windows

Download the latest Windows release package from [Releases](https://github.com/vickwv/D3Macro/releases/latest), extract it, and launch `D3Macro-Windows.exe`.

### Development Setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python d3keyhelper.py --init-config
python d3keyhelper.py --gui
```

## CLI Usage

```bash
python d3keyhelper.py --gui
python d3keyhelper.py
python d3keyhelper.py --init-config
python d3keyhelper.py --list-profiles
python d3keyhelper.py --profile 1
python d3keyhelper.py --capture-backend kde-wayland
python d3keyhelper.py --any-window
python d3keyhelper.py --config ~/.config/d3macro/d3oldsand.ini
```

## Configuration

Profiles are stored as INI sections and can be managed through the GUI.

Default config locations:

- Linux: `~/.config/d3macro/d3oldsand.ini`
- Windows: `%APPDATA%\d3macro\d3oldsand.ini`

The GUI auto-detects the system language. You can also switch language from the toolbar or set `D3HELPER_LANG=zh|en|zh_TW` before launch.

## Architecture

D3Macro is organized into several platform-independent layers:

- **Input layer**: keyboard and mouse automation with platform-aware dispatch
- **Capture layer**: screenshot abstraction for X11, KDE Wayland, and desktop capture
- **Vision layer**: inventory recognition, safezone logic, and UI state detection
- **Automation layer**: combat rotation runner and helper workflows
- **GUI layer**: Qt desktop interface with multilingual support

## Design Philosophy

D3Macro operates entirely outside the game process.

It does not use:

- DLL injection
- memory patching
- kernel drivers
- game file modification

All automation is performed through normal desktop input, window detection, and visual recognition.

## Build

### Linux AppImage

```bash
./build_appimage.sh
```

Output:

```text
build/appimage/D3Macro-Linux-x86_64.AppImage
```

If your default `python` does not provide `pip`, set `PYTHON_BIN` to a Python 3.11 interpreter with pip before running the build script.

### Windows

```bat
build_windows.bat
```

Output:

```text
dist\D3Macro-Windows.exe
```

## Tests

```bash
python -m unittest discover -s tests
```

## Credits

D3Macro was originally derived from [D3keyHelper](https://github.com/WeijieH/D3keyHelper) by Weijie Huang and has since evolved into a cross-platform desktop automation project.
