# D3Macro

[![AppImage Build](https://github.com/vickwv/D3Macro/actions/workflows/build-appimage.yml/badge.svg)](https://github.com/vickwv/D3Macro/actions/workflows/build-appimage.yml)
[![Windows Build](https://github.com/vickwv/D3Macro/actions/workflows/build-windows.yml/badge.svg)](https://github.com/vickwv/D3Macro/actions/workflows/build-windows.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

**Language:** English | [简体中文](./README.zh-CN.md)

Cross-platform **Diablo III macro automation tool** for skill rotation, visual detection, and gameplay assistance on Windows and Linux, including KDE Wayland.

D3Macro is a **Diablo 3 automation tool** built for players who want configurable skill rotation macros, screenshot-based game state detection, and cross-platform desktop automation without invasive game modification.

It is designed as a **safe external macro solution**: no DLL injection, no memory patching, and no kernel drivers - only visual detection, game window awareness, and desktop input automation.

## What is D3Macro?

D3Macro is a **Diablo III macro / skill rotation tool** that helps automate repetitive gameplay tasks such as:

- skill rotation automation
- timed, repeated, and hold-based macro execution
- screenshot-based inventory and UI state recognition
- per-profile combat configuration for different builds

Unlike keystroke-only or AutoHotkey-style macros, D3Macro is built for:

- Linux Wayland compatibility
- visual-based automation workflows
- window-aware input handling
- cross-platform profile management

## Problem

Diablo III combat often requires repetitive skill timing and manual rotation.

Most macro tools focus on simple input replay or Windows-first workflows, which makes them a weak fit for Linux desktops, Wayland sessions, and screenshot-driven automation.

## Solution

D3Macro provides a cross-platform external automation system using:

- visual detection
- game window detection
- platform-aware input dispatch
- configurable skill rotation profiles

## Why D3Macro

Traditional macro tools usually stop at key repetition.

D3Macro extends that with:

- game window awareness
- visual state detection
- platform-aware input handling
- Linux Wayland compatibility
- configurable combat profiles
- integrated Qt desktop GUI
- no-injection external automation

For players looking for an alternative to AutoHotkey-style Diablo III macros, D3Macro focuses on visual recognition, window-aware automation, and Linux-friendly desktop support.

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

That makes it a practical **Linux game macro tool**, **Wayland automation tool**, and **cross-platform macro tool** for Diablo III players who need visual detection instead of process injection.

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

## Keywords

Diablo 3 macro, Diablo III automation tool, Diablo 3 skill rotation tool, Linux game macro tool, Wayland automation tool, cross-platform macro tool, visual detection automation, pixel based automation tool, safe external macro, no injection game automation, alternative to AutoHotkey for Diablo III

## Changelog

### v2.0.1 (2026-05-07)

**Bug Fixes**

- **Smart Pause — double-tap to prevent accidental triggers**
  Previously a single Tab keypress immediately paused the macro, and a single Enter/M/T immediately stopped it — very easy to trigger accidentally.
  Now requires a **double-tap within 0.35 s**:
  - Double-tap **Tab** → pause / resume macro
  - Double-tap **Enter, M, or T** (only while already paused) → stop macro
  - Suppressed when **Ctrl / Alt / Shift / Win** is held, so hotkeys work normally

- **Helper hotkey (F5) blocked while macro is running**
  Previously pressing F5 while the battle macro was running showed "Combat macro is running; helper will not start."
  Now if the macro is running and not paused when F5 is pressed, it **auto-pauses** for the duration of the helper; once the helper finishes it **auto-resumes**.
  Typical flow: run macro in combat → return to town → press F5 to salvage — no need to stop the macro manually.

- **System tray icon blank**
  After the v2.0.0 rename to D3Macro the icon file was renamed to `d3macro-256.png`, but the code still searched for the old name `d3keyhelper-linux-256.png`, leaving the tray icon empty.
  Now searches `d3macro-256.png` first and falls back to the old name.

---

## Credits

D3Macro was originally derived from [D3keyHelper](https://github.com/WeijieH/D3keyHelper) by Weijie Huang and has since evolved into a cross-platform desktop automation project.
