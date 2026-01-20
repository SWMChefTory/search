# Changelog

All notable changes to the Cheftory Search (Logstash/OpenSearch) configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- 향후 추가될 검색/인덱싱 관련 기능들

### Changed
- 향후 변경될 Logstash 파이프라인 및 OpenSearch 매핑

### Fixed
- 향후 수정될 검색/자동완성 관련 버그들

---

## [1.0.9] - 2026-01-20

### Added

- `search_query_template.json`:
  - `market`, `scope`, `id`, `searchText`, `title`, `servings_text`, `ingredients`, `channel_title`, `keywords`, `created_at`, `updated_at` 필드를 포함하는 검색 인덱스 매핑 추가
  - Nori 기반 본문 분석기와 edge n-gram 기반 자동완성용 서브 필드 정의
- `autocomplete_template.json`:
  - 자동완성 전용 `autocomplete` 인덱스 템플릿 추가 (`market`, `scope`, `text`, `count` 필드)
  - nori/icu/analyzer 및 edge n-gram 토크나이저를 활용한 자동완성 분석기 구성
- `recipes_delete.conf` + `recipes_delete.sql`:
  - `BLOCK` 상태 레시피를 `search_query` 인덱스에서 삭제하는 전용 Logstash 파이프라인 및 SQL 추가
- `pipelines.yml`:
  - `recipes-pipeline`, `recipes-delete-pipeline`, `autocomplete-pipeline` 파이프라인 등록

### Changed

- `recipes.conf`:
  - 기존 `recipes` 인덱스 대신 `search_query` 인덱스로 색인하도록 변경
  - `search_query_template.json`을 사용해 검색 인덱스 매핑을 자동 관리하도록 설정
- `recipes.sql`:
  - 레시피 색인 시 `market`, `scope('recipe')`, `servings_text`, 재료(`ingredients_json`), 태그(`tags_json`), 타임스탬프(`created_at`, `updated_at`)를 함께 조회하도록 확장
  - `recipe_status = 'SUCCESS'` 조건만 색인 대상으로 유지
- `autocomplete.conf`:
  - 자동완성 인덱스를 `autocomplete`로 명시하고, 템플릿을 `autocomplete_template.json`으로 정비
- `autocomplete.sql`:
  - 자동완성 후보에 `market`, `scope('recipe')`, `text`, `count`(가중치 기반 합산)를 포함하도록 쿼리 개편
  - 제목, 채널명, 재료, 태그, 인분 정보 등 다양한 텍스트 소스를 가중치 기반으로 통합

### Fixed

- `BLOCK` 상태 레시피가 검색 인덱스에 남아있는 문제:
  - 별도의 삭제 파이프라인(`recipes-delete-pipeline`)을 통해 `BLOCK` 상태 레시피가 주기적으로 `search_query`에서 삭제되도록 개선

---

## Release Notes

### 배포 방법

```bash
# Release 브랜치 생성
git checkout -b release/1.0.0

# version = '1.0.0' 으로 수정

# CHANGELOG.md 업데이트
# 변경사항 작성

# 커밋 및 푸시
git add CHANGELOG.md
git commit -m "chore: release v1.0.0"
git push origin release/1.0.0

# main 브랜치로 PR 생성 및 머지

# 태그 생성 및 푸시 (main 브랜치에서)
git tag v1.0.0
git push origin v1.0.0
```

태그 푸시 시 자동으로:
- GitHub Release 생성
- Docker 이미지 빌드 및 배포
- Production 환경 배포
