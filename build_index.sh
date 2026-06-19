#!/usr/bin/env bash
# 掃描 reports/ 中所有 YYYY-MM-DD.html 頁面，依日期由新到舊產生 index.html
set -euo pipefail
cd "$(dirname "$0")"

ITEMS=""
# 依檔名反向排序（日期新到舊）
for f in $(ls reports/ 2>/dev/null | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.html$' | sort -r); do
  date="${f%.html}"
  ITEMS="${ITEMS}      <li><a href=\"reports/${f}\">${date}　每日選股<span class=\"arrow\">›</span></a></li>\n"
done

if [ -z "$ITEMS" ]; then
  ITEMS="      <li>尚無報告</li>\n"
fi

LATEST=$(ls reports/ 2>/dev/null | grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}\.html$' | sort -r | head -1 | sed 's/\.html//') || true

cat > index.html <<EOF
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>每日選股｜台股 × 美股</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<header class="site">
  <h1>📈 每日選股</h1>
  <div class="sub">台股 × 美股｜AI 自動產生的每日觀察</div>
</header>

<div class="wrap">
  <div class="market-note">
    每天更新一份精選清單（台股 3 檔、美股 3 檔），含建議買入價、目標價、停損與風險提醒。
    最新一期：<strong>${LATEST:-（無）}</strong>。點選下方日期瀏覽歷史紀錄。
  </div>

  <h2 class="section">歷史報告</h2>
  <ul class="archive-list">
$(printf "%b" "$ITEMS")  </ul>

  <div class="disclaimer">
    本網站內容由 AI 自動產生，僅供參考，非投資建議。報價可能延遲或不精確，投資前請自行評估風險。
  </div>

  <footer class="site">每日選股 · 自動更新</footer>
</div>
</body>
</html>
EOF

echo "index.html 已產生，最新報告：${LATEST:-無}"
