# Java Hello World — CI/CD with GitHub Actions & GitLab CI

This repo gives you a **minimal but production-shaped** Java 17 app with **both**:
- **GitHub Actions** workflow (`.github/workflows/ci.yml`)
- **GitLab CI** pipeline (`.gitlab-ci.yml`)
- Dockerized build & runtime

## Quickstart - Claudio Souza

```bash
# Run locally
./scripts/run_local.sh

# Or with Docker
./scripts/docker_run.sh
```

## Requirements
- Java 17 + Maven
- (Optional) Docker for container builds
- (Optional) Accounts on GitHub and GitLab

## CI/CD Overview

### GitHub Actions
- Triggers on `push` and `pull_request`
- Builds & tests with Maven
- (Optional) Builds and pushes a Docker image to **GitHub Container Registry (GHCR)** when `GHCR_TOKEN` secret is set.

Add the following repository secret if you want to push to GHCR:
- `GHCR_TOKEN`: a classic PAT with `write:packages` scope.

### GitLab CI
- Stages: `build`, `test`, `docker`
- Uses `docker:dind` to build/push image to the **GitLab Container Registry**.
- Configure these CI/CD variables in GitLab:
  - `CI_REGISTRY_USER`
  - `CI_REGISTRY_PASSWORD` (or `CI_REGISTRY_PASSWORD` / `CI_REGISTRY_TOKEN`)
  - `CI_REGISTRY` (usually pre-defined)
  - `CI_REGISTRY_IMAGE` (usually pre-defined)

## GitHub ↔ GitLab mirroring

### Option A — GitLab pulls from GitHub (recommended)
1. Create the project on GitLab (empty).
2. In **Settings → Repository → Mirroring repositories**, add your GitHub repo HTTPS URL and a GitHub **PAT** with `repo` read access.
3. Choose **Pull** mirror, enable **Automatic**, and save.

### Option B — GitHub pushes to GitLab
1. Create a **Deploy Key** or **PAT** on GitLab.
2. Add a GitHub Action that `git push`es to the GitLab remote on `main` (example snippet below).

```yaml
# .github/workflows/mirror-to-gitlab.yml (optional)
name: Mirror to GitLab
on:
  push:
    branches: [ "main" ]
jobs:
  mirror:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Git
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
      - name: Push to GitLab
        env:
          GITLAB_URL: ${{ secrets.GITLAB_URL }}
          GITLAB_TOKEN: ${{ secrets.GITLAB_TOKEN }}
        run: |
          git remote add gitlab "$GITLAB_URL"
          git push --force --prune gitlab +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/*
```

## Project Structure

```
.
├─ src/
│  ├─ main/java/com/example/app/App.java
│  └─ test/java/com/example/app/AppTest.java
├─ .github/workflows/ci.yml
├─ .gitlab-ci.yml
├─ Dockerfile
├─ pom.xml
└─ scripts/
   ├─ run_local.sh
   └─ docker_run.sh
```

## Customize
- Change `groupId`, `artifactId`, `version` in `pom.xml`.
- Rename Docker image targets in CI files if desired.
- Add quality gates (Checkstyle, SpotBugs) and coverage (Jacoco) as you grow.

Enjoy! 🚀
