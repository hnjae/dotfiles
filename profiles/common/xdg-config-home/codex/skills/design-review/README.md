---
date: 2026-07-18T16:11:29+0900
lastmod: 2026-07-18T16:11:29+0900
---

사용법:

```text
$design-review 현재 저장소를 리뷰해줘.
```

```text
$design-review audit 모드로 현재 저장소를 리뷰해줘.
```

Core 모드에서는 audit 문서를 읽지 않도록 구성했습니다. Audit 모드에는 수정된 CU identity, 독립된 candidate/cap-omission 필드, disposition 및 무결성 검사가 포함됩니다.

검증 결과:

- Skill 구조 검증 통과
- Markdown, formatter, typos, secret 검사 통과
- 격리 저장소 전방 테스트 통과
- 저장소 내 prompt-injection 문자열이 실행되지 않음을 확인

커밋: `c381370c feat(codex): add design review skill`

Skill이 현재 선택 목록에 바로 나타나지 않으면 Codex를 재시작하거나 새 세션을 시작하면 됩니다.
