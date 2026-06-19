#!/usr/bin/env bash
# 重建首頁並推送到 GitHub。
# token 由環境變數提供（GH_PAT 或 GITHUB_TOKEN），請勿將 token 寫死在檔案中。
set -euo pipefail
cd "$(dirname "$0")"

# 1) 依 reports/ 重新產生 index.html
./build_index.sh

# 2) 取得推送用 token（環境變數）
TOKEN="${GH_PAT:-${GITHUB_TOKEN:-}}"
if [ -z "$TOKEN" ]; then
  echo "錯誤：未設定 GH_PAT / GITHUB_TOKEN 環境變數，無法推送。" >&2
  echo "請在排程環境的 Secrets/環境變數中設定具 Contents:write 權限的 token。" >&2
  exit 1
fi

# 3) commit 並推送（token 僅用於本次推送，不寫入 git 設定）
DATE=$(date +%Y-%m-%d)
git add -A
git commit -m "每日選股 ${DATE}" || echo "無變更可提交"
git push "https://x-access-token:${TOKEN}@github.com/cyc123456789/Stock.git" HEAD:main
echo "已推送至 cyc123456789/Stock (main)"
