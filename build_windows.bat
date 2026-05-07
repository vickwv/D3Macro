@echo off
setlocal

set PYTHON_BIN=python
set APP_NAME=D3Macro-Windows
set ROOT_DIR=%~dp0
set ICON_PNG=%ROOT_DIR%packaging\icons\d3macro-256.png
set ICON_ICO=%ROOT_DIR%packaging\icons\d3macro.ico

echo === D3Macro Windows Build ===

%PYTHON_BIN% -m pip install --upgrade pip
%PYTHON_BIN% -m pip install -r "%ROOT_DIR%requirements.txt"
%PYTHON_BIN% -m pip install pyinstaller

echo === Generating icon ===
%PYTHON_BIN% -c "from PIL import Image; sizes=[(256,256),(128,128),(64,64),(48,48),(32,32),(16,16)]; base=Image.open(r'%ICON_PNG%').convert('RGBA'); imgs=[base.resize(s, Image.LANCZOS) for s in sizes]; imgs[0].save(r'%ICON_ICO%', format='ICO', sizes=sizes)"
if errorlevel 1 (
  echo WARNING: Icon generation failed. Building without custom icon.
  set ICON_ICO=
  goto :build_without_icon
)

:build_with_icon
%PYTHON_BIN% -m PyInstaller ^
  --noconfirm ^
  --clean ^
  --windowed ^
  --onefile ^
  --name "%APP_NAME%" ^
  --hidden-import pynput.keyboard._win32 ^
  --hidden-import pynput.mouse._win32 ^
  --collect-submodules mss ^
  --collect-submodules pynput ^
  --add-data "%ROOT_DIR%mainwindow.png;." ^
  --add-data "%ICON_PNG%;." ^
  --add-data "%ICON_ICO%;." ^
  --icon "%ICON_ICO%" ^
  "%ROOT_DIR%d3keyhelper_gui.py"
goto :build_done

:build_without_icon
%PYTHON_BIN% -m PyInstaller ^
  --noconfirm ^
  --clean ^
  --windowed ^
  --onefile ^
  --name "%APP_NAME%" ^
  --hidden-import pynput.keyboard._win32 ^
  --hidden-import pynput.mouse._win32 ^
  --collect-submodules mss ^
  --collect-submodules pynput ^
  --add-data "%ROOT_DIR%mainwindow.png;." ^
  --add-data "%ICON_PNG%;." ^
  "%ROOT_DIR%d3keyhelper_gui.py"

:build_done
echo.
echo === Build complete: dist\%APP_NAME%.exe ===
endlocal
