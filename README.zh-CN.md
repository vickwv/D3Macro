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

## 致谢

D3Macro 最初基于 [D3keyHelper](https://github.com/WeijieH/D3keyHelper) 演进而来，现已发展为一个面向跨平台桌面自动化的独立项目。
