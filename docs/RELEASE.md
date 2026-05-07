# 发布流程 / Release Process

## 概览

打一个版本标签并推送到 GitHub，CI 会自动完成以下工作：

1. 运行测试套件
2. 构建 Linux AppImage（`D3Macro-Linux-vX.X.X-x86_64.AppImage`）
3. 构建 Windows 可执行文件（`D3Macro-Windows-vX.X.X.exe`）
4. 创建 GitHub Release，附上发布日志和两个构建产物

---

## 发布前检查

```bash
# 1. 确保本地测试全部通过
source .venv/bin/activate
python -m unittest discover -s tests
# 期望输出：Ran N tests in Xs — OK
```

---

## 发布步骤

### 第 1 步：写发布日志

在 `.github/release-notes/` 目录下新建 `vX.X.X.md`，参考已有文件格式（中英双语）：

```
.github/release-notes/
├── v2.0.0.md   ← 参考格式
└── v2.0.1.md
```

文件结构示例：

```markdown
# vX.X.X – 本次版本主题

## What's New / Bug Fixes

- **功能/修复说明（英文）**：描述……

---

## 新功能 / Bug 修复（中文）

- **功能/修复说明**：描述……
```

> **注意**：如果发布时该文件不存在，CI 会自动生成一份仅含 git log 摘要的默认日志，但建议手动编写以保证质量。

### 第 2 步：更新 README 更新日志章节

同步在 `README.md` 和 `README.zh-CN.md` 末尾的 `## Changelog / ## 更新日志` 章节中追加本次版本记录。

### 第 3 步：提交所有改动

```bash
git add .
git commit -m "chore: prepare vX.X.X release"
git push origin main
```

### 第 4 步：打标签并推送

```bash
git tag -a vX.X.X -m "vX.X.X"
git push origin main --tags
```

推送标签后，GitHub Actions 会自动触发构建和发布流程。

---

## 验证发布结果

前往 [GitHub Releases](https://github.com/vickwv/D3Macro/releases)，确认：

- [ ] Release 已创建，标题为 `vX.X.X`
- [ ] 发布日志内容正确（来自 `.github/release-notes/vX.X.X.md`）
- [ ] 附件包含 `D3Macro-Linux-vX.X.X-x86_64.AppImage`
- [ ] 附件包含 `D3Macro-Windows-vX.X.X.exe`

---

## 版本号规范

遵循 [Semantic Versioning](https://semver.org/)：

| 类型 | 示例 | 适用场景 |
|------|------|----------|
| Patch | `v2.0.1` | Bug 修复，无破坏性变更 |
| Minor | `v2.1.0` | 新功能，向后兼容 |
| Major | `v3.0.0` | 破坏性变更，重大重构 |

---

## 相关文件

| 文件 | 说明 |
|------|------|
| `.github/release-notes/vX.X.X.md` | 每个版本的发布日志（中英双语） |
| `.github/workflows/build-appimage.yml` | Linux AppImage 构建 + 发布 CI |
| `.github/workflows/build-windows.yml` | Windows exe 构建 + 发布 CI |
| `README.md` | 英文文档（含 Changelog 章节） |
| `README.zh-CN.md` | 中文文档（含更新日志章节） |
| `build_appimage.sh` | 本地手动构建 AppImage 脚本 |
| `build_windows.bat` | 本地手动构建 Windows exe 脚本 |
