# mly-relay

Public relay station for C-CLAW (大头虾) environment.

## Purpose

大头虾环境无法直连 GitHub，但有 `cap-webfetch` API 可以抓取公开 URL。
本仓库作为中转站，将大头虾需要的安装包、工具脚本、配置模板放在公开仓里，
让大头虾通过 `raw.githubusercontent.com` 直接拉取。

## Rules

1. **不含任何凭据** — 无 token、key、密码
2. **不含隐私数据** — 无投资记录、体重数据、个人画像
3. **不含公司内部文档** — 无密级限制内容
4. **只放公开可分发内容** — 开源软件、MIT/Apache 协议脚本、脱敏模板

## Structure

```
mly-relay/
├── README.md              ← 本文件
├── opencode/              ← OpenCode 安装脚本和依赖
│   └── install.sh
├── skills/                ← 开源 skill 镜像
├── tools/                 ← 通用工具脚本（无敏感信息）
└── config/                ← 脱敏配置模板
```

## Usage (大头虾侧)

```bash
# 通过 cap-webfetch 拉取文件
cap-webfetch("https://raw.githubusercontent.com/ryeboymly/mly-relay/main/opencode/install.sh")
```

## Owner

ryeboymly (60401094)
