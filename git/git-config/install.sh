#!/usr/bin/env bash
set -e

# ─────────────────────────────────────────────────────
# install.sh: 이 스크립트를 실행하면 현재 Git 리포지토리의
# .git/hooks/prepare-commit-msg 훅이 이모지 자동 변환 훅으로 설치됩니다.
# Usage: cd path/to/your-repo && curl -fsSL <RAW‑URL>/install.sh | bash
# ─────────────────────────────────────────────────────

# 0) 변수 설정
REPO_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$REPO_ROOT/.git/hooks"

PREPARE_COMMIT_MSG_URL="https://raw.githubusercontent.com/10se-rr/TIL/main/git/git-config/hooks/prepare-commit-msg"


# 1) 해당 디렉토리가 깃 디렉토리인지 확인
if [ ! -d "$REPO_ROOT/.git/hooks" ]; then
  echo "✖ 이 디렉터리는 Git 리포지토리가 아닙니다: $REPO_ROOT"
  exit 1
fi

# 2) 세팅 파일 내려 받기
## 1. prepare-commit-msg 스크립트 내려받기
curl -fsSL "$PREPARE_COMMIT_MSG_URL" -o "$HOOKS_DIR/prepare-commit-msg"

# 3) 실행 권한 부여
chmod +x "$HOOKS_DIR/prepare-commit-msg"

# 4) 완료 메시지
REPO_NAME=$(basename "$REPO_ROOT")
echo "✔️ ${REPO_NAME} commit 이모지 설치 -완-!"
