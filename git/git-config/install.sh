#!/usr/bin/env bash
set -e

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
MSG_FILE=$1
SOURCE=$2

# 1) 머지/스쿼시 건너뛰기
if [[ "$SOURCE" == "merge" || "$SOURCE" == "squash" ]]; then exit 0; fi

# 2) 첫 줄 읽기
FIRST_LINE=$(head -n1 "$MSG_FILE")

# 3) 키워드→이모지 매핑
emoji=""; new="$FIRST_LINE"
case "$FIRST_LINE" in
  init:*)     emoji="🎉"; new="${FIRST_LINE#init:}"    ;;
  feat:*)     emoji="✨"; new="${FIRST_LINE#feat:}"    ;;
  refactor:*) emoji="♻️"; new="${FIRST_LINE#refactor:}" ;;
  fix:*)      emoji="🔧"; new="${FIRST_LINE#fix:}"     ;;
  style:*)    emoji="💄"; new="${FIRST_LINE#style:}"   ;;
  docs:*)     emoji="📝"; new="${FIRST_LINE#docs:}"    ;;
  build:*)    emoji="🏗️"; new="${FIRST_LINE#build:}"   ;;
  test:*)     emoji="💯"; new="${FIRST_LINE#test:}"   ;;
  devops:*)   emoji="🐳"; new="${FIRST_LINE#devops:}"   ;;
  *) 
    echo "✖ 커밋 메시지 컨벤션 오류: init:, feat:, refactor:, fix:, style:, docs:, build:, test:, devops: 중 하나로 시작해야 합니다." >&2
    exit 1
    ;;
esac

# 4) 앞뒤 공백 제거
trimmed="$(echo "$new" | sed -E 's/^[[:space:]]+//;s/[[:space:]]+$//')"

# 5) 첫 줄 교체 (macOS/Linux 자동 분기)
if sed --version >/dev/null 2>&1; then
  sed -i "1s~.*~$emoji $trimmed~" "$MSG_FILE"
else
  sed -i '' "1s~.*~$emoji $trimmed~" "$MSG_FILE"
fi
EOF

# 3) 실행 권한 부여
chmod +x "$HOOKS_DIR/prepare-commit-msg"

# 4) 완료 메시지
REPO_NAME=$(basename "$REPO_ROOT")
echo "✔️ ${REPO_NAME}에 commit 이모지 설정 -완-"
