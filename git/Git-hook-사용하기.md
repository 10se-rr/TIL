# Git hook 사용하기

## 깃훅(Git hook)이란?
git에서 제공하는 프로세스(커밋, 푸시, 리베이스 등)의 전이나 후 이벤트를 후킹하여 특정 액션을 실행하는 스크립트를 git hook 이라고 한다.

## 여러가지 Git hooks
- applypatch-msg
- pre-applypatch
- post-applypatch
- pre-commit
- prepare-commit-msg (커밋 메시지를 바꿀 수 있음)
- commit-msg
- post-commit
- pre-rebase
- post-checkout
- post-merge
- pre-receive
- update
- post-receive
- post-update
- pre-auto-gc
- post-rewrite
- pre-push

## Git hook 사용법 

### 로컬 저장소 내 스크립트를 수정하는 방법

깃허브 로컬 저장소 폴더 내 `./git/hooks` 경로에 사용하고자 하는 깃훅 이벤트명으로 확장자가 없는 실행 가능한 스크립트를 넣으면 된다.

>실행 스크립트 파일을 만들었다. 아래로 커맨드를 실행하는 방식으로 쥔장은 쓴다.
```
curl -fsSL https://raw.githubusercontent.com/10se-rr/TIL/main/git/git-config/install.sh | bash
```
