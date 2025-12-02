# Design: Offline Support & Caching Strategy

## Current Issue
- `NovelPage` (Episode Viewer) depends on `novelInfoProvider`.
- `novelInfoProvider` fetches data exclusively from the Narou API.
- Offline access fails even if episode content is cached, because the metadata (TOC) fetch fails.

## Proposed Solution
Implement a "Network First, Fallback to Database" strategy for Novel Metadata.

## Implementation Details

### 1. NovelInfo Model Extension
- Add functionality to convert `Novel` (Drift Database Entity) to `NovelInfo` (Domain Model).
- **Note**: Cached `NovelInfo` from the `Novels` table does not contain the `episodes` list (Table of Contents).

### 2. Provider Logic Update (`lib/services/api_service.dart`)
- Modify `novelInfoProvider` and `novelInfoWithCacheProvider`.
- **Flow**:
  1.  Attempt to fetch `NovelInfo` from API.
  2.  **Success**: Return API data (contains full TOC and `revised` dates).
  3.  **Failure (Exception)**:
      - Query `AppDatabase` for the novel.
      - If found: Convert to `NovelInfo` and return.
      - If not found: Rethrow exception (Error screen).

### 3. Caching Behavior
- **Online**:
  - `NovelInfo` is fetched from API (ensures fresh TOC and `revised` dates).
  - Episode Content is fetched ONLY IF:
    - Not cached locally.
    - OR Cached version is older than `revised` date from TOC.
  - This optimizes bandwidth while ensuring content freshness.

- **Offline**:
  - `NovelInfo` is retrieved from DB (Fallback).
  - **Limitations**:
    - `episodes` list (TOC) is null/empty.
    - Latest revision dates are unknown.
  - **Behavior**:
    - `NovelPage` receives `null` for `revised` date.
    - `NovelRepository` skips revision check and returns cached episode content if available.
    - User can read cached episodes seamlessly.

## Impact on UI
- **Offline**:
  - Viewer opens successfully using cached metadata (Title, Total Episodes).
  - Table of Contents in Viewer might be empty (no episode titles).
  - Navigation (Next/Prev) works based on episode numbers.
- **Online**:
  - No change in behavior (Freshness guaranteed, efficient caching used).
