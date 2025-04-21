# prepare-commit-msg 

## 개요

[Git hook 사용하기](./git/Git-hook-사용하기.md) 에서 언급한 바와 같이 로컬 저장소의 `./git/hooks/prepare-commit-msg`를 추가하여, `commit-message`에 컨벤션 이모지를 추가할 수 있다.


## 설명
![prepare-commit-msg.sample](./images/prepare-commit-msg.png)

위는 `./.git/hooks` 디렉토리 안의 prepare-commit-msg.sample이다. 설명과 같이 `git commit` 명령어로 호출되고, `commit-file`과 `commit-message`를 인자로 받아서 실행된다. 이 훅의 목적은 커밋 메세지를 파일을 수정하기 위해 존재한다.

[예시] [prepare-commit-msg](https://github.com/10se-rr/TIL/blob/main/git/git-config/hooks/prepare-commit-msg)

해당 파일을 `./.git/hooks`에 추가 하면된다.