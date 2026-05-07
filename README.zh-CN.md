# D3Macro

[![AppImage Build](https://github.com/vickwv/D3Macro/actions/workflows/build-appimage.yml/badge.svg)](https://github.com/vickwv/D3Macro/actions/workflows/build-appimage.yml)
[![Windows Build](https://github.com/vickwv/D3Macro/actions/workflows/build-windows.yml/badge.svg)](https://github.com/vickwv/D3Macro/actions/workflows/build-windows.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

**语言：** [English](./README.md) | 简体中文

面向 **Diablo III / Diablo 3** 的跨平台宏与自动化工具，支持技能循环、视觉识别，以及 Windows 与 Linux（包括 KDE Wayland）桌面环境。

D3Macro 是一个面向暗黑破坏神 III 玩家设计的 **Diablo 3 automation tool / Diablo 3 macro**，提供可配置技能循环、基于截图的游戏状态检测，以及**不侵入游戏进程**的跨平台桌面自动化能力。

它被设计成一个 **safe external macro solution**：不使用 DLL 注入、不修改内存、不依赖内核驱动，而是通过视觉识别、游戏窗口感知和桌面输入自动化完成工作。

## D3Macro 是什么？

D3Macro 可以理解为一个 **Diablo III macro / skill rotation tool**，适合自动处理这类重复操作：

- 技能循环自动化
- 定时、重复、按住等宏动作执行
- 基于截图的背包与 UI 状态识别
- 面向不同流派的配置档管理

和只做按键回放的宏脚本、或偏 AutoHotkey 风格的方案相比，D3Macro 更强调：

- Linux Wayland 兼容
- 基于视觉识别的自动化流程
- 游戏窗口感知输入
- 跨平台配置档管理

## Problem / 问题

暗黑破坏神 III 的战斗经常依赖重复性的技能时序与手动循环。

很多宏工具主要围绕简单按键回放或 Windows 优先的工作流构建，这让它们在 Linux 桌面、Wayland 会话以及依赖截图识别的场景下并不理想。

## Solution / 方案

D3Macro 提供一套运行在游戏进程之外的跨平台自动化方案，核心包括：

- 视觉识别
- 游戏窗口检测
- 平台感知输入分发
- 可配置技能循环配置档

## 为什么选择 D3Macro

传统宏工具通常只停留在按键重复。

D3Macro 在此基础上进一步提供：

- 游戏窗口感知
- 视觉状态识别
- 平台感知的输入处理
- Linux Wayland 兼容
- 可配置战斗配置档
- 集成式 Qt 桌面 GUI
- 无注入的外部自动化方案

如果你在找一个可替代 AutoHotkey 风格脚本的 Diablo III 宏工具，D3Macro 的重点是视觉识别、窗口感知自动化，以及对 Linux 桌面的实际支持。

这让它在不同桌面环境和暗黑破坏神 III 的实际玩法场景中，都能提供更稳定的自动化行为。

## 战斗自动化

- 可配置的技能循环配置档
- 支持定时、重复、按住等多种技能动作
- 支持配置档热键与运行时切换
- 支持全局开始 / 停止热键与快速暂停
- 同时提供 GUI 启动方式与终端运行器

## 视觉识别

- 面向 Diablo III 会话的活动窗口识别
- 基于截图的背包、仓库、赌博、卡奈魔盒状态检测
- 用于保护背包位置的安全格映射
- 面向 X11、KDE Wayland 和 Windows 桌面环境的截图 / 检测后端

## 跨平台支持

| 平台 | 状态 | 说明 |
|------|------|------|
| Linux X11 / XWayland | ✅ 推荐 | 当前最完整、最直接的使用方式 |
| KDE Wayland | ✅ 支持 | 基于 KWin 窗口查询与 Spectacle 截图 |
| Windows | ✅ 支持 | 使用 ctypes 进行前台窗口识别 |

D3Macro 最有技术辨识度的部分之一，就是现代 Linux 桌面上的游戏自动化，尤其是 KDE Wayland 场景下对窗口识别与截图链路的打通。

这也让它更接近用户实际会搜索的 **Linux game macro tool**、**Wayland automation tool** 和 **cross-platform macro tool** 这类定位。

## 截图

### 主控制窗口

![Main Window](./mainwindow.png)

### 安全格识别

![Safezone](./safezone.png)

## 快速开始

### Linux

从 [Releases](https://github.com/vickwv/D3Macro/releases/latest) 下载最新 AppImage：

```bash
chmod +x D3Macro-Linux-x86_64.AppImage
./D3Macro-Linux-x86_64.AppImage
```

### Windows

从 [Releases](https://github.com/vickwv/D3Macro/releases/latest) 下载最新 Windows 发布包，解压后运行 `D3Macro-Windows.exe`。

### 开发环境

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python d3keyhelper.py --init-config
python d3keyhelper.py --gui
```

## CLI 用法

```bash
python d3keyhelper.py --gui
python d3keyhelper.py
python d3keyhelper.py --init-config
python d3keyhelper.py --list-profiles
python d3keyhelper.py --profile 配置1
python d3keyhelper.py --capture-backend kde-wayland
python d3keyhelper.py --any-window
python d3keyhelper.py --config ~/.config/d3macro/d3oldsand.ini
```

## 配置文件

配置档以 INI section 的形式保存，可以直接通过 GUI 管理。

默认配置路径：

- Linux：`~/.config/d3macro/d3oldsand.ini`
- Windows：`%APPDATA%\d3macro\d3oldsand.ini`

GUI 会自动识别系统语言。你也可以通过顶部工具栏切换，或在启动前设置 `D3HELPER_LANG=zh|en|zh_TW`。

## 架构

D3Macro 按平台无关的层次组织：

- **输入层**：键盘 / 鼠标自动化与平台感知事件发送
- **截图层**：面向 X11、KDE Wayland 和桌面截图的抽象
- **视觉层**：背包识别、安全格逻辑与界面状态检测
- **自动化层**：战斗循环运行器与辅助流程
- **GUI 层**：带多语言支持的 Qt 桌面界面

## 设计理念

D3Macro 完全运行在游戏进程之外。

它不会使用：

- DLL 注入
- 内存补丁
- 内核驱动
- 游戏文件修改

所有自动化行为都基于常规桌面输入、窗口识别和视觉检测完成。

## 构建

### Linux AppImage

```bash
./build_appimage.sh
```

输出：

```text
build/appimage/D3Macro-Linux-x86_64.AppImage
```

如果默认 `python` 不带 `pip`，请先将 `PYTHON_BIN` 指向一个带 `pip` 的 Python 3.11 解释器，再执行构建脚本。

### Windows

```bat
build_windows.bat
```

输出：

```text
dist\D3Macro-Windows.exe
```

## 测试

```bash
python -m unittest discover -s tests
```

## Keywords / 关键词

Diablo 3 macro, Diablo III automation tool, Diablo 3 skill rotation tool, Linux game macro tool, Wayland automation tool, cross-platform macro tool, visual detection automation, pixel based automation tool, safe external macro, no injection game automation, alternative to AutoHotkey for Diablo III

## 更新日志

### v2.0.4（2026-05-07）

**Bug 修复（Windows）**

- **标题栏左上角无图标**：Windows 下窗口标题栏和任务栏按钮不显示图标。修复方案：在 `MainWindow.__init__()` 中紧随 `setWindowTitle()` 之后立即调用 `setWindowIcon()`，确保 HWND 创建时图标已到位。
- **系统托盘图标不可见 / 缺少切换配置菜单**：`QIcon` 为空时 `QSystemTrayIcon` 在 Windows 下不可见。三处同步修复：(1) `build_windows.bat` 新增 `--add-data` 将 `d3macro.ico` 一并打包进 PyInstaller 包（之前仅作为 EXE 资源嵌入）；(2) `app_icon_path()` 在 Windows 下优先查找 `d3macro.ico`（ICO 含多分辨率，不依赖 Qt 的 PNG 插件，运行时更可靠）；(3) `_build_tray_icon()` 在文件图标与窗口图标均为空时回退到 Qt 内置 `SP_TitleBarMenuButton` 图标，保证通知区域入口始终可见。

### v2.0.3（2026-05-07）

**Bug 修复**

- **Windows 非中文系统（cp1252）启动崩溃 UnicodeEncodeError**：运行器在非中文 Windows 下启动时立即崩溃。PyInstaller 打包后 `sys.stdout` 按 Windows ANSI 代码页初始化，`PYTHONIOENCODING` 尚未生效，第一条中文 `print()` 即崩溃。修复方案：在两处 runner 入口开头显式调用 `sys.stdout.reconfigure(encoding='utf-8', errors='replace')`。

### v2.0.2（2026-05-07）

**Bug 修复（Windows）**

- **EXE 缺少图标**：构建脚本现在从 PNG 生成 `.ico` 并通过 `--icon` 传给 PyInstaller。
- **运行日志中文乱码**：中文 Windows 子进程默认 GBK 编码，修复方案为注入 `PYTHONIOENCODING=utf-8` 和 `PYTHONUTF8=1`。
- **点击启动 / 日志刷新时界面卡顿**：`waitForStarted` 阻塞主线程；托盘菜单每条日志都重建。改为异步 `errorOccurred` 信号，仅在状态变化时重建托盘菜单。
- **下拉框出现透明玻璃质感多余圆圈**：Fluent 半透明 QSS 在纯白背景下产生光晕，通过 `setCustomStyleSheet` 替换为不透明颜色。
- **Windows 下字体很细看不清**：Fluent 控件默认 `Segoe UI`，中文回退到宋体（SimSun）。修复方案：启动时调用 `setFontFamilies(['Microsoft YaHei', ...])` 并将全局 `font-weight: 400` 升级为 `500`。

### v2.0.1（2026-05-07）

**Bug 修复**

- **智能暂停 — 防误触双击逻辑**
  原来 Tab 键单击即触发暂停，回车/M/T 键单击即停止宏，极易误触发。
  现改为 **0.35 秒内连击两次** 才触发：
  - 双击 **Tab** → 暂停 / 恢复宏
  - 宏已暂停时双击 **回车、M、T** → 停止宏（未暂停时无效，防止误停）
  - **按住 Ctrl / Alt / Shift / Win** 时不触发，方便正常使用组合键

- **助手热键（F5）在宏运行时无法触发**
  原来战斗宏运行期间按 F5 会提示"战斗宏运行中，当前不会启动助手"，必须先停宏才能用助手。
  现在按 F5 时，若宏正在运行且未暂停，宏会**自动暂停**；助手执行完毕后**自动恢复**。
  典型场景：开着战斗宏刷图 → 回主城 → 直接按 F5 分解装备，无需手动停宏。

- **系统托盘图标显示空白**
  v2.0.0 项目更名为 D3Macro 后，图标文件名也改为 `d3macro-256.png`，但代码仍搜索旧文件名 `d3keyhelper-linux-256.png`，导致托盘图标为空。
  现在优先搜索 `d3macro-256.png`，找不到时回退到旧文件名。

---

## 致谢

D3Macro 最初基于 [D3keyHelper](https://github.com/WeijieH/D3keyHelper) 演进而来，现已发展为一个面向跨平台桌面自动化的独立项目。
