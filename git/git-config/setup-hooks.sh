# setup-hooks.sh

# 1) 리포지토리 최상위 경로에서 이름 추출
REPO_NAME=$(basename "$(git rev-parse --show-toplevel)")

# 2) hooks 경로 설정
git config core.hooksPath hooks

# 3) 사용자 메시지 출력
echo "✔️ ${REPO_NAME}에 Custom 훅이 적용되었습니다."
