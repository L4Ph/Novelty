---
name: releasing-novelty
description: Automates the release process for the Novelty project and its packages. Generates release notes, bumps versions, builds artifacts, and creates releases. Use when the user wants to release a new version of the app or a package.
---

# Novelty Release Process

## Workflow Selection

Determine if you are releasing the **Main App** or a **Specific Package**.

### 📱 Main App Release
Follow [App Release Workflow](#app-release-workflow) below.

### 📦 Package Release
Follow [Package Release Workflow](#package-release-workflow) below.

---

## App Release Workflow

Copy this checklist and check off items as you complete them:

```
App Release Progress:
- [ ] Step 1: Analyze changes & Generate Release Notes
- [ ] Step 2: Bump App Version
- [ ] Step 3: Commit & Push
- [ ] Step 4: Build Release Artifacts
- [ ] Step 5: Create GitHub Release
```

### Step 1: Analyze changes & Generate Release Notes

1.  Run the script to get changes since the last tag:
    ```bash
    bash skills/releasing-novelty/scripts/get_changes.sh
    ```
2.  Based on the output, ask Claude to generate release notes in **Japanese** using the following template (No Emojis).

    **Template:**
    ```markdown
    ## 主な変更点

    ### 新機能
    - [機能の説明]

    ### バグ修正
    - [修正内容の説明]

    ### その他
    - [その他の変更]
    ```

    *   **Prompt**: "Generate release notes in Japanese based on these changes using the provided template (No Emojis). Group by Features (新機能), Fixes (バグ修正), and Others (その他). Use a friendly and professional tone."

### Step 2: Bump App Version

Decide the bump type (`major`, `minor`, `patch`, or `build`).

Run the bash script to update `pubspec.yaml`:
```bash
bash skills/releasing-novelty/scripts/bump_version.sh [type] pubspec.yaml
```

### Step 3: Commit & Push

```bash
git add pubspec.yaml
git commit -m "chore: bump version"
git push
```

### Step 4: Build Release Artifacts

Build the application using mise:
```bash
mise run build
```

### Step 5: Create GitHub Release

```bash
# Get the new version from pubspec
VERSION="v$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d+ -f1)"

# Create release
gh release create "$VERSION" \
  --title "$VERSION" \
  --notes "[Paste Release Notes Here]" \
  build/app/outputs/bundle/release/app-release.aab \
  build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk \
  build/app/outputs/flutter-apk/app-arm64-v8a-release.apk \
  build/app/outputs/flutter-apk/app-x86_64-release.apk
```

---

## Package Release Workflow

Copy this checklist and check off items as you complete them:

```
Package Release Progress:
- [ ] Step 1: Identify Package
- [ ] Step 2: Analyze Package Changes
- [ ] Step 3: Bump Package Version
- [ ] Step 4: Commit & Tag
```

### Step 1: Identify Package

Identify the package directory (e.g., `packages/narou_parser`).

### Step 2: Analyze Package Changes

Run the script targeting the package directory:
```bash
bash skills/releasing-novelty/scripts/get_changes.sh packages/[package_name]
```

### Step 3: Bump Package Version

Decide the bump type (`major`, `minor`, `patch`).

Run the bash script to update the package's `pubspec.yaml`:
```bash
bash skills/releasing-novelty/scripts/bump_version.sh [type] packages/[package_name]/pubspec.yaml
```

### Step 4: Commit & Tag

Create a commit and a tag specifically for this package version (Mono-repo style tag: `package_name-vX.Y.Z`).

```bash
PACKAGE_NAME="[package_name]"
PACKAGE_PATH="packages/$PACKAGE_NAME/pubspec.yaml"
VERSION=$(grep 'version:' "$PACKAGE_PATH" | awk '{print $2}' | cut -d+ -f1)
TAG_NAME="${PACKAGE_NAME}-v${VERSION}"

git add "$PACKAGE_PATH"
git commit -m "chore($PACKAGE_NAME): bump version to $VERSION"
git tag "$TAG_NAME"
git push origin main
git push origin "$TAG_NAME"

echo "Released $TAG_NAME"
```
