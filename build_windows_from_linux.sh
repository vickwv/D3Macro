#!/usr/bin/env bash
# Build D3Macro-Windows.exe from a Linux host.
#
# ── Why Wine / Docker is required ────────────────────────────────────────────
# True cross-compilation (mingw-w64 etc.) is NOT possible for this project.
# PyInstaller only builds for the OS it runs on.  PySide6, numpy, pynput and
# mss all ship as pre-built Windows PE binaries — they must be executed by a
# Windows Python interpreter to be bundled correctly.
# The solution is to run a Windows Python interpreter via Wine, either directly
# on the host (BUILD_MODE=wine) or inside an isolated Docker container
# (BUILD_MODE=docker, the default).
#
# ── Modes ─────────────────────────────────────────────────────────────────────
#   docker (default)
#     Builds inside a Debian container with Wine + Python 3.11 for Windows.
#     The Docker image is built once and cached as d3macro-win-builder:<ver>.
#     Requirements: docker (Arch: sudo pacman -S docker)
#                   sudo systemctl start docker   (or enable it)
#
#   wine
#     Uses Wine installed on the host directly.
#     Requirements (Arch): sudo pacman -S wine
#                          sudo pacman -S xorg-server-xvfb  # for headless
#
# ── Usage ─────────────────────────────────────────────────────────────────────
#   ./build_windows_from_linux.sh               # Docker mode (default)
#   BUILD_MODE=wine ./build_windows_from_linux.sh
#
# ── Output ────────────────────────────────────────────────────────────────────
#   dist/D3Macro-Windows.exe  (--onefile bundle)
#
# ── Environment overrides ─────────────────────────────────────────────────────
#   PYTHON_WIN_VERSION   Windows Python version to install  (default: 3.11.9)
#   DOCKER_IMAGE_TAG     Override the builder image tag
#   WINE_PREFIX          Override Wine prefix path (wine mode only)

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ROOT_DIR}/build/win-build"
DIST_DIR="${ROOT_DIR}/dist"
APP_NAME="D3Macro-Windows"

PYTHON_WIN_VERSION="${PYTHON_WIN_VERSION:-3.11.9}"
BUILD_MODE="${BUILD_MODE:-docker}"

ICON_DIR="${ROOT_DIR}/packaging/icons"
ICON_PNG="${ICON_DIR}/d3macro-256.png"
ICON_ICO="${ICON_DIR}/d3macro.ico"

die()      { echo "ERROR: $*" >&2; exit 1; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Command not found: $1"; }

# ── shared: generate ICO on the host (native Pillow is faster / simpler) ──────

gen_ico() {
    local native_python=""
    for candidate in \
        "${ROOT_DIR}/.venv311/bin/python" \
        "${ROOT_DIR}/.venv/bin/python" \
        python3 python; do
        if command -v "${candidate}" >/dev/null 2>&1 && \
                "${candidate}" -c "import PIL" 2>/dev/null; then
            native_python="${candidate}"
            break
        fi
    done
    if [[ -z "${native_python}" ]]; then
        echo "WARNING: Pillow not found in any native Python; skipping ICO regen."
        return
    fi
    if [[ ! -f "${ICON_ICO}" ]] || [[ "${ICON_PNG}" -nt "${ICON_ICO}" ]]; then
        echo "=== Generating d3macro.ico ==="
        ICON_DIR="${ICON_DIR}" "${native_python}" - <<'PY'
import os
from PIL import Image
root = os.environ['ICON_DIR']
sizes = [(256,256),(128,128),(64,64),(48,48),(32,32),(16,16)]
base = Image.open(f'{root}/d3macro-256.png').convert('RGBA')
imgs = [base.resize(s, Image.LANCZOS) for s in sizes]
imgs[0].save(f'{root}/d3macro.ico', format='ICO', append_images=imgs[1:], sizes=sizes)
print(f"  Wrote {root}/d3macro.ico")
PY
    fi
}

# ── shared: PyInstaller argument list (Windows path separator ;) ───────────────

pyinstaller_args() {
    local args=(
        -m PyInstaller
        --noconfirm --clean --windowed --onefile
        --name "${APP_NAME}"
        --hidden-import "pynput.keyboard._win32"
        --hidden-import "pynput.mouse._win32"
        --collect-submodules mss
        --collect-submodules pynput
        "--add-data" "${ROOT_DIR}/mainwindow.png;."
        "--add-data" "${ICON_PNG};."
        "--distpath" "${DIST_DIR}"
        "--workpath" "${BUILD_DIR}/pyinstaller-work"
        "--specpath" "${BUILD_DIR}"
    )
    if [[ -f "${ICON_ICO}" ]]; then
        args+=( "--add-data" "${ICON_ICO};." "--icon" "${ICON_ICO}" )
    fi
    args+=( "${ROOT_DIR}/d3keyhelper_gui.py" )
    printf '%s\0' "${args[@]}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# Docker mode
# ═══════════════════════════════════════════════════════════════════════════════

build_docker() {
    need_cmd docker
    need_cmd curl

    local image_tag="${DOCKER_IMAGE_TAG:-d3macro-win-builder:py${PYTHON_WIN_VERSION}}"
    local dockerfile="${BUILD_DIR}/Dockerfile.windows"

    mkdir -p "${BUILD_DIR}" "${DIST_DIR}"
    gen_ico

    # Write the Dockerfile only if it doesn't exist yet (or the version changed).
    cat > "${dockerfile}" <<DOCKERFILE
# syntax=docker/dockerfile:1
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \\
    WINEPREFIX=/opt/wineprefix \\
    WINEARCH=win64 \\
    WINEDEBUG=-all \\
    DISPLAY=:1

ARG PYTHON_WIN_VERSION=${PYTHON_WIN_VERSION}

# Install Wine (64-bit) + utilities.  Adding i386 is required even for win64
# because wine's internal libraries are 32-bit.
RUN dpkg --add-architecture i386 \\
    && apt-get update \\
    && apt-get install -y --no-install-recommends \\
        wine wine64 wine32 xvfb ca-certificates curl \\
    && rm -rf /var/lib/apt/lists/*

# Initialise Wine prefix (headless via Xvfb)
RUN Xvfb :1 -screen 0 800x600x16 -nolisten tcp & \\
    sleep 2 && \\
    wineboot --init 2>/dev/null; \\
    sleep 2; \\
    wineserver --wait 2>/dev/null; \\
    pkill Xvfb 2>/dev/null; \\
    true

# Download and silently install Python \${PYTHON_WIN_VERSION} for Windows (x64)
RUN curl -sSL \\
        "https://www.python.org/ftp/python/\${PYTHON_WIN_VERSION}/python-\${PYTHON_WIN_VERSION}-amd64.exe" \\
        -o /tmp/py.exe \\
    && Xvfb :1 -screen 0 800x600x16 -nolisten tcp & \\
    sleep 2 && \\
    wine /tmp/py.exe /quiet InstallAllUsers=0 TargetDir='C:\\\\Python311' \\
        PrependPath=0 Shortcuts=0 Include_doc=0 Include_launcher=0 \\
    && sleep 5 && wineserver --wait 2>/dev/null; \\
    pkill Xvfb 2>/dev/null; \\
    rm /tmp/py.exe; \\
    true

WORKDIR /src
ENTRYPOINT ["bash", "/src/build/_docker_build_entrypoint.sh"]
DOCKERFILE

    # Write the entrypoint that runs inside the container.
    cat > "${BUILD_DIR}/_docker_build_entrypoint.sh" <<'ENTRYPOINT'
#!/usr/bin/env bash
set -euo pipefail
WINE_PYTHON="wine /opt/wineprefix/drive_c/Python311/python.exe"

echo "=== Installing Python dependencies ==="
Xvfb :1 -screen 0 800x600x16 -nolisten tcp &>/dev/null &
sleep 2
export DISPLAY=:1

$WINE_PYTHON -m pip install --upgrade pip -q
$WINE_PYTHON -m pip install -r /src/requirements.txt -q
$WINE_PYTHON -m pip install pyinstaller -q

echo "=== Running PyInstaller ==="
# Read null-delimited args written by the host script
mapfile -d '' PYARGS < /src/build/win-build/pyinstaller_args.bin
$WINE_PYTHON "${PYARGS[@]}"

# Fix ownership so the host user owns the output
if [[ -n "${HOST_UID:-}" ]] && [[ -n "${HOST_GID:-}" ]]; then
    chown -R "${HOST_UID}:${HOST_GID}" /src/dist /src/build/win-build 2>/dev/null || true
fi
ENTRYPOINT
    chmod +x "${BUILD_DIR}/_docker_build_entrypoint.sh"

    # Build the Docker image if not already cached.
    if ! docker image inspect "${image_tag}" &>/dev/null; then
        echo "=== Building Docker image ${image_tag} (one-time, ~5 min) ==="
        docker build \
            --build-arg "PYTHON_WIN_VERSION=${PYTHON_WIN_VERSION}" \
            -t "${image_tag}" \
            -f "${dockerfile}" \
            "${BUILD_DIR}"
    else
        echo "=== Using cached Docker image ${image_tag} ==="
    fi

    # Serialise PyInstaller args as NUL-delimited for the entrypoint.
    pyinstaller_args > "${BUILD_DIR}/pyinstaller_args.bin"

    echo "=== Running build inside container ==="
    docker run --rm \
        -v "${ROOT_DIR}:/src" \
        -e "HOST_UID=$(id -u)" \
        -e "HOST_GID=$(id -g)" \
        "${image_tag}"

    echo ""
    echo "=== Build complete ==="
    echo "Output: ${DIST_DIR}/${APP_NAME}/${APP_NAME}.exe"
}

# ═══════════════════════════════════════════════════════════════════════════════
# Wine mode  (host Wine, no Docker needed)
# ═══════════════════════════════════════════════════════════════════════════════

build_wine() {
    need_cmd wine
    need_cmd curl

    local wine_prefix="${WINE_PREFIX:-${BUILD_DIR}/wine-prefix}"
    local installer_cache="${BUILD_DIR}/python-${PYTHON_WIN_VERSION}-amd64.exe"
    local wine_python="${wine_prefix}/drive_c/Python311/python.exe"

    mkdir -p "${BUILD_DIR}" "${DIST_DIR}"
    gen_ico

    wine_run() {
        WINEPREFIX="${wine_prefix}" WINEARCH=win64 WINEDEBUG=-all \
            DISPLAY="${DISPLAY:-:1}" wine "$@"
    }

    # Virtual display for headless environments
    local xvfb_pid=""
    if [[ -z "${DISPLAY:-}" ]]; then
        Xvfb :1 -screen 0 1024x768x24 -nolisten tcp &
        xvfb_pid=$!
        export DISPLAY=:1
        sleep 1
        trap '[[ -n "${xvfb_pid}" ]] && kill "${xvfb_pid}" 2>/dev/null || true' EXIT
    fi

    # Initialise Wine prefix once
    if [[ ! -f "${wine_prefix}/system.reg" ]]; then
        echo "=== Initialising Wine prefix ==="
        WINEPREFIX="${wine_prefix}" WINEARCH=win64 WINEDEBUG=-all \
            DISPLAY="${DISPLAY}" wineboot --init 2>/dev/null || true
        sleep 3
        WINEPREFIX="${wine_prefix}" wineserver --wait 2>/dev/null || true
    fi

    # Download Python installer (cached)
    if [[ ! -f "${installer_cache}" ]]; then
        echo "=== Downloading Python ${PYTHON_WIN_VERSION} for Windows ==="
        curl -L --progress-bar \
            "https://www.python.org/ftp/python/${PYTHON_WIN_VERSION}/python-${PYTHON_WIN_VERSION}-amd64.exe" \
            -o "${installer_cache}"
    fi

    # Install Python into the Wine prefix (idempotent)
    if [[ ! -f "${wine_python}" ]]; then
        echo "=== Installing Python ${PYTHON_WIN_VERSION} into Wine prefix ==="
        wine_run "${installer_cache}" /quiet \
            InstallAllUsers=0 TargetDir='C:\Python311' \
            PrependPath=0 Shortcuts=0 Include_doc=0 Include_launcher=0
        sleep 5
        WINEPREFIX="${wine_prefix}" wineserver --wait 2>/dev/null || true
        [[ -f "${wine_python}" ]] || die "Python install failed (${wine_python} not found)"
    fi

    echo "=== Installing Python dependencies ==="
    wine_run "${wine_python}" -m pip install --upgrade pip -q
    wine_run "${wine_python}" -m pip install -r "${ROOT_DIR}/requirements.txt" -q
    wine_run "${wine_python}" -m pip install pyinstaller -q

    echo "=== Running PyInstaller ==="
    mapfile -d '' pyargs < <(pyinstaller_args)
    wine_run "${wine_python}" "${pyargs[@]}"

    echo ""
    echo "=== Build complete ==="
    echo "Output: ${DIST_DIR}/${APP_NAME}/${APP_NAME}.exe"
}

# ── dispatch ──────────────────────────────────────────────────────────────────

case "${BUILD_MODE}" in
    docker) build_docker ;;
    wine)   build_wine ;;
    *)      die "Unknown BUILD_MODE '${BUILD_MODE}'. Use 'docker' or 'wine'." ;;
esac
