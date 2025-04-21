# Git hook으로 컨벤션 이모지

## index

[Git hook 사용하기](./git/Git-hook-사용하기.md) 에서 언급한 바와 같이 2가지 방법이 가능하다.
1. 로컬의 `./git/hook` 경로에 스크립트를 추가하는 방법

2. 원격 저장소 > Settings > Webhooks 메뉴에서 URL을 설정하는 방법


## 방법 1. 로컬 ./.git/hooks 수정
![commit-message](./images/prepare-commit-msg.png)

위는 `./.git/hook/` 디렉토리 안의 prepare-commit-msg.sample이다. 설명과 같이 `git commit` 명령어로 호출되고, `commit-file`과 `commit-message`를 인자로 받아서 실행된다. 이 훅의 목적은 커밋 메세지를 파일을 수정하기 위해 존재한다.
설명에 따르면 해당 파일을 통해서 커밋의 컨벤션에 맞춰서 이모지를 추가가 가능하다.

아래는 `install.sh`로 만들었다.
```
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

```


이제 해당 커맨드로 로컬 깃에 설정을 넣을 수 있다.
```
curl -fsSL https://raw.githubusercontent.com/10se-rr/TIL/main/git/git-config/install.sh | bash
```


## 2번 방법
1. 