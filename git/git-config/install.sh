#!/usr/bin/env bash
set -e

# ─────────────────────────────────────────────────────
# install.sh: 이 스크립트를 실행하면 현재 Git 리포지토리의
# .git/hooks/prepare-commit-msg 훅이 이모지 자동 변환 훅으로 설치됩니다.
# Usage: cd path/to/your-repo && curl -fsSL <RAW‑URL>/install.sh | bash
# ─────────────────────────────────────────────────────

# 0) 레포 최상위 경로
REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/.git/hooks"

# 1) 원본 훅(.sample) 제거
if [ -f "$HOOKS_DIR/prepare-commit-msg.sample" ]; then
  rm "$HOOKS_DIR/prepare-commit-msg.sample"
fi

# 2) prepare-commit-msg 스크립트 생성
cat > "$HOOKS_DIR/prepare-commit-msg" << 'EOF'
#!/usr/bin/env bash
# .git/hooks/prepare-commit-msg

MSG_FILE=$1
SOURCE=$2

# 1) 머지/스쿼시 커밋 건너뛰기
if [[ "$SOURCE" == "merge" || "$SOURCE" == "squash" ]]; then
  exit 0
fi

# 2) 첫 줄 읽기
FIRST_LINE=$(head -n1 "$MSG_FILE")

# 3) 키워드→이모지 매핑 (본문은 그대로 유지)
emoji=""
case "$FIRST_LINE" in
  init:*)     emoji="🎉"  ;;
  feat:*)     emoji="✨"  ;;
  refactor:*) emoji="♻️" ;;
  fix:*)      emoji="🔧"  ;;
  style:*)    emoji="💄"  ;;
  docs:*)     emoji="📝"  ;;
  build:*)    emoji="🏗️" ;;
  test:*)     emoji="💯"  ;;
  devops:*)   emoji="🐳"  ;;
  *) 
    echo "✖ 커밋 메시지 컨벤션 오류: init:, feat:, refactor:, fix:, style:, docs:, build:, test:, devops: 중 하나로 시작해야 합니다." >&2
    exit 1
    ;;
esac

# 본문은 원래 메시지 그대로
new="$FIRST_LINE"

# 4) 앞뒤 공백 제거
trimmed="$(echo "$new" | sed -E 's/^[[:space:]]+//;s/[[:space:]]+$//')"

# 5) 첫 줄 교체 (macOS/Linux 자동 분기)
if sed --version >/dev/null 2>&1; then
  # GNU sed (Linux, Git Bash)
  sed -i "1s~.*~$emoji $trimmed~" "$MSG_FILE"
else
  # BSD sed (macOS)
  sed -i '' "1s~.*~$emoji $trimmed~" "$MSG_FILE"
fi
EOF

# 3) 실행 권한 부여
chmod +x "$HOOKS_DIR/prepare-commit-msg"

# 4) 완료 메시지
REPO_NAME=$(basename "$REPO_ROOT")
echo "✔️ ${REPO_NAME} commit 이모지 설치 -완-!"
