# 大头虾 Agent 工具指南

> 本文件指导 C-CLAW（大头虾）环境中的 AI Agent 如何使用 mly-relay 公开仓中的工具。
> 环境：Debian 12 / K8s / root / 112核 754G / GitHub不通 / cap-webfetch可穿透

---

## 目录

1. [工具总览](#工具总览)
2. [快速开始](#快速开始)
3. [各工具安装与使用](#各工具安装与使用)
4. [组合方案](#组合方案)
5. [故障排查](#故障排查)

---

## 工具总览

| 序号 | 工具 | 类别 | 用途 | 协议 |
|------|------|------|------|------|
| 1 | ttyd | Web终端 | 通过浏览器共享终端 | MIT |
| 2 | code-server | 浏览器IDE | VS Code 跑在浏览器 | MIT |
| 3 | verdaccio | NPM镜像 | 私有npm代理+离线缓存 | MIT |
| 4 | cf-proxy-ex | GitHub代理 | Cloudflare超级代理 | - |
| 5 | CF-GitHub-Proxy | GitHub镜像 | Workers中转GitHub请求 | MIT |
| 6 | gitport-github | GitHub加速 | 绕过DNS污染 | Apache-2.0 |
| 7 | camofox-browser | 隐身浏览器 | AI Agent反检测浏览 | MIT |
| 8 | pydoll | 浏览器自动化 | 无WebDriver CDP直连 | MIT |
| 9 | invisible_playwright | 反检测PW | 隐身Playwright | MIT |
| 10 | claude-code-devcontainer | 沙箱容器 | 安全隔离AI运行环境 | Apache-2.0 |
| 11 | claude-code-docker | 网络隔离容器 | iptables白名单 | - |
| 12 | scrapper | Web抓取API | Docker内REST抓取 | MIT |

---

## 快速开始

### Step 1: 拉取本仓库

```bash
# 方式A: 如果 git 可用
git clone https://github.com/ryeboymly/mly-relay.git

# 方式B: 如果只有 cap-webfetch，逐文件拉取
# 用 cap-webfetch 获取 raw.githubusercontent.com/ryeboymly/mly-relay/main/<path>
```

### Step 2: 选择你需要的工具

根据场景选择：
- **需要操作终端** → ttyd
- **需要写代码** → code-server
- **需要装 npm 包** → verdaccio
- **需要访问 GitHub** → CF-GitHub-Proxy 或 cf-proxy-ex
- **需要浏览器自动化** → invisible_playwright 或 pydoll
- **需要隔离运行** → claude-code-devcontainer

### Step 3: 执行安装脚本

```bash
cd mly-relay
bash tools/install_<tool_name>.sh
```

---

## 各工具安装与使用

### 1. ttyd — Web 终端

**用途：** 把后端终端暴露到浏览器，大头虾前端嵌入 iframe 即可操作。

```bash
bash tools/install_ttyd.sh
```

**使用：**
```bash
# 启动（端口 7681）
ttyd --port 7681 bash

# 带密码
ttyd --port 7681 -c user:password bash

# 大头虾前端嵌入
# <iframe src="http://<server-ip>:7681"></iframe>
```

**项目地址：** https://github.com/tsl0922/ttyd

---

### 2. code-server — 浏览器 VS Code

**用途：** 完整 IDE 体验，79.8K star，K8s 友好。

```bash
bash tools/install_code_server.sh
```

**使用：**
```bash
# 启动（端口 8080）
code-server --bind-addr 0.0.0.0:8080

# 配置文件位置
# ~/.config/code-server/config.yaml
```

**项目地址：** https://github.com/coder/code-server

---

### 3. verdaccio — NPM 私有镜像代理

**用途：** 解决大头虾不通 npm registry 的问题，缓存所有包支持离线。

```bash
bash tools/install_verdaccio.sh
```

**使用：**
```bash
# Docker 启动（端口 4873）
docker run -d --name verdaccio -p 4873:4873 verdaccio/verdaccio

# 配置 npm 使用本地镜像
npm config set registry http://localhost:4873

# 之后所有 npm install 自动走缓存
npm install playwright
```

**项目地址：** https://github.com/verdaccio/verdaccio

---

### 4. cf-proxy-ex — Cloudflare 超级代理

**用途：** GitHub 加速 + 在线代理，多平台部署。

```bash
bash tools/install_cf_proxy.sh
```

**使用：**
```bash
# 部署到 Cloudflare Workers
# 详见 https://github.com/1234567Yang/cf-proxy-ex

# 部署后通过 Worker URL 访问 GitHub
git clone https://<your-worker>.workers.dev/https://github.com/user/repo.git
```

**项目地址：** https://github.com/1234567Yang/cf-proxy-ex

---

### 5. CF-GitHub-Proxy — GitHub 镜像代理

**用途：** Cloudflare Workers 中转 GitHub 请求。

```bash
bash tools/install_cf_github_proxy.sh
```

**使用：**
```bash
# 部署到 Cloudflare Workers/Snippets
# 详见 https://github.com/hubporg/CF-GitHub-Proxy

# 使用代理克隆
git clone https://<your-worker>.workers.dev/https://github.com/user/repo.git
```

**项目地址：** https://github.com/hubporg/CF-GitHub-Proxy

---

### 6. gitport-github — GitHub 加速器

**用途：** 内置真实 IP 表绕过 DNS 污染，Rust 实现。

```bash
bash tools/install_gitport.sh
```

**使用：**
```bash
# 启动本地代理（默认端口 8181）
./gitport-github

# 配置 git 使用代理
git config --global http.proxy http://127.0.0.1:8181
git clone https://github.com/user/repo.git
```

**项目地址：** https://github.com/zhidian-cmd/gitport-github

---

### 7. camofox-browser — AI Agent 隐身浏览器

**用途：** 绕过 Cloudflare、bot 检测、反爬，MIT 协议。

```bash
bash tools/install_camofox.sh
```

**使用：**
```javascript
const { browser } = require('camofox-browser');

const page = await browser.newPage();
await page.goto('https://example.com');
const content = await page.content();
```

**项目地址：** https://github.com/jo-inc/camofox-browser

---

### 8. pydoll — 无 WebDriver 浏览器自动化

**用途：** CDP 直连 Chromium，反指纹，7.1K star。

```bash
bash tools/install_pydoll.sh
```

**使用：**
```python
import asyncio
from pydoll.browser.chromium import Chrome

async def main():
    browser = Chrome()
    await browser.start()
    page = await browser.get_page()
    await page.go_to('https://example.com')
    print(await page.page_source)
    await browser.stop()

asyncio.run(main())
```

**项目地址：** https://github.com/autoscrape-labs/pydoll

---

### 9. invisible_playwright — 反检测 Playwright

**用途：** 同 Playwright API 但隐身，反验证码。

```bash
bash tools/install_invisible_pw.sh
```

**使用：**
```python
from invisible_playwright import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto('https://example.com')
    print(page.content())
    browser.close()
```

**项目地址：** https://github.com/feder-cr/invisible_playwright

---

### 10. claude-code-devcontainer — 沙箱化 DevContainer

**用途：** 安全审计模式运行 AI Agent，Apache-2.0。

```bash
bash tools/install_devcontainer.sh
```

**使用：**
```bash
# 需要 Docker
git clone https://github.com/trailofbits/claude-code-devcontainer.git
cd claude-code-devcontainer
docker build -t sandbox-agent .
docker run -it --rm sandbox-agent
```

**项目地址：** https://github.com/trailofbits/claude-code-devcontainer

---

### 11. claude-code-docker — 网络隔离容器

**用途：** iptables 白名单限制 AI Agent 对外连接。

```bash
bash tools/install_network_docker.sh
```

**使用：**
```bash
git clone https://github.com/deancourse/claude-code-docker-container.git
cd claude-code-docker-container
# 编辑白名单 IP 列表
# ./setup.sh
```

**项目地址：** https://github.com/deancourse/claude-code-docker-container

---

### 12. scrapper — Web 抓取 REST API

**用途：** Docker 内 REST API + 无头浏览器 + Readability.js。

```bash
bash tools/install_scrapper.sh
```

**使用：**
```bash
# Docker 启动（端口 8080）
docker run -d --name scrapper -p 8080:8080 amerkurev/scrapper

# 调用 API
curl "http://localhost:8080/?url=https://example.com"
```

**项目地址：** https://github.com/amerkurev/scrapper

---

## 组合方案

### 方案 A: 最小可用（推荐起步）

```
ttyd + verdaccio
```
- ttyd 解决终端操作
- verdaccio 解决 npm 离线安装
- 覆盖 80% 场景

### 方案 B: 完整开发环境

```
code-server + verdaccio + CF-GitHub-Proxy
```
- code-server 提供完整 IDE
- verdaccio 缓存 npm 包
- CF-GitHub-Proxy 解决 GitHub 访问

### 方案 C: 浏览器自动化

```
invisible_playwright + verdaccio
```
- invisible_playwright 反检测浏览
- verdaccio 缓存 Playwright 依赖

### 方案 D: 安全隔离

```
claude-code-devcontainer + ttyd
```
- devcontainer 隔离运行环境
- ttyd 提供外部访问入口

---

## 故障排查

### Q: git clone 失败怎么办？
A: 使用 cap-webfetch 逐文件拉取 raw.githubusercontent.com 内容，或部署 CF-GitHub-Proxy。

### Q: npm install 超时？
A: 部署 verdaccio 作为本地镜像，`npm config set registry http://localhost:4873`。

### Q: Docker 不可用？
A: ttyd 和 code-server 都有独立二进制，不需要 Docker。pydoll 可直接 pip install。

### Q: Playwright Chromium 下载失败？
A: 使用 `tools/install_playwright.sh` 脚本，支持 npx 和 python 双通道。如均失败，从其他机器下载后 scp 到 `~/.cache/ms-playwright/`。

### Q: 端口被占用？
A: 所有脚本默认端口可在启动参数修改：ttyd(7681)、code-server(8080)、verdaccio(4873)、scrapper(8080)。

---

## 文件清单

```
mly-relay/
├── docs/
│   ├── c-claw-docs.md                 C-Claw 社区文档镜像
│   └── agent-guide.md                 本文件（大头虾 Agent 工具指南）
├── tools/
│   ├── install_ttyd.sh                Web 终端
│   ├── install_code_server.sh         浏览器 VS Code
│   ├── install_verdaccio.sh           NPM 镜像代理
│   ├── install_cf_proxy.sh            Cloudflare 超级代理
│   ├── install_cf_github_proxy.sh     GitHub 镜像代理
│   ├── install_gitport.sh             GitHub 加速器
│   ├── install_camofox.sh             AI 隐身浏览器
│   ├── install_pydoll.sh              无 WebDriver 自动化
│   ├── install_invisible_pw.sh        反检测 Playwright
│   ├── install_devcontainer.sh        沙箱 DevContainer
│   ├── install_network_docker.sh      网络隔离容器
│   ├── install_scrapper.sh            Web 抓取 API
│   ├── install_playwright.sh          Playwright Chromium
│   └── install_precommit.sh           pre-commit
├── config/
│   └── .pre-commit-config.yaml        pre-commit 配置模板
└── README.md
```

---

*最后更新: 2026-11-12 | Owner: ryeboymly (60401094)*
