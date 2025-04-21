# setup-hooks.sh

# 1) 변수 설정
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2) hooks 경로 설정
git config core.hooksPath "$SCRIPT_DIR/hooks"

# 3) 사용자 메시지 출력
echo "✔️ ${REPO_NAME}에 Custom 훅이 적용되었습니다."

