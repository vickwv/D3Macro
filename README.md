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

### v2.0.5 (2026-05-08)

**Bug Fixes & Improvements (Windows)**

- **Taskbar / title-bar icon shows Qt logo instead of D3Macro icon**: `packaging/icons/d3macro.ico` is now pre-generated and committed to the repository, so the ICO is always present without relying on a build-time Pillow step that could silently fail. `SetCurrentProcessExplicitAppUserModelID` is now called on Windows at startup so the OS correctly associates the window with our embedded EXE icon in the taskbar.
- **Runner restart is slow on Windows**: Two-part fix: (1) `stop_runner()` now waits only 400 ms before force-killing on Windows instead of the previous 3 000 ms — Python processes don't handle `WM_CLOSE` from `terminate()` so the old timeout was always fully spent; (2) `_launch_runner()` now passes `sys._MEIPASS` as `_MEIPASS2` to the subprocess environment — the PyInstaller bootloader skips re-extraction when this variable is set, eliminating the 2–5 s startup penalty per runner restart. Build stays `--onefile` (single `.exe`).

**New: Linux → Windows cross-build script**

- Added `build_windows_from_linux.sh` — build the Windows `.exe` on Arch Linux / any Linux host without running Windows.
  - **Docker mode (default)**: builds inside a Debian container with Wine + Python 3.11 for Windows; no Wine needed on the host (`sudo pacman -S docker`).
  - **Wine mode**: `BUILD_MODE=wine ./build_windows_from_linux.sh` — uses host Wine directly (`sudo pacman -S wine`).
  - Docker image is built once and cached; subsequent runs skip straight to PyInstaller.

### v2.0.4 (2026-05-07)

**Bug Fixes (Windows)**

- **Title bar icon missing**: The window title bar and taskbar button showed no icon on Windows. Fixed by calling `setWindowIcon()` inside `MainWindow.__init__()` immediately after the window title is set, ensuring the icon is applied before the HWND is ever shown.
- **System tray icon invisible / missing profile-switch menu**: `QSystemTrayIcon` on Windows is invisible when given a null `QIcon`. Fixed three-ways: (1) `build_windows.bat` now bundles `d3macro.ico` into the PyInstaller package via `--add-data` in addition to passing it as the EXE resource icon; (2) `app_icon_path()` searches for `d3macro.ico` first on Windows (ICO is natively multi-resolution and doesn't depend on Qt's PNG plugin at runtime); (3) `_build_tray_icon()` falls back to Qt's built-in `SP_TitleBarMenuButton` icon if both the file-based and app-window icons are null, guaranteeing the notification-area entry is always visible.

### v2.0.3 (2026-05-07)

**Bug Fixes**

- **UnicodeEncodeError on startup (Western Windows / cp1252)**: The runner crashed immediately on non-Chinese Windows with `UnicodeEncodeError: 'charmap' codec can't encode characters`. PyInstaller initialises `sys.stdout` with the Windows ANSI code page before `PYTHONIOENCODING` is read. Fixed by calling `sys.stdout.reconfigure(encoding='utf-8', errors='replace')` at both runner entry points.

---

## Credits

D3Macro was originally derived from [D3keyHelper](https://github.com/WeijieH/D3keyHelper) by Weijie Huang and has since evolved into a cross-platform desktop automation project.
