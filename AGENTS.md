# Project Overview

This is a Flutter project called "Novelty," a cross-platform novel viewer for the website "小説家になろう" (Let's Become a Novelist). The application is designed to provide an optimal reading experience, built from the ground up with a focus on simplicity and modern features. It is a client application for the "小説家になろう" website and is developed using the Flutter framework, ensuring a consistent and comfortable user experience across iOS, Android, and desktop platforms (Windows, macOS, Linux).

The project uses a modern and robust technology stack, including:
- **Framework:** Flutter
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Database:** Drift (SQLite)
- **API Client:** tiny_http
- **CI/CD:** GitHub Actions

## Building and Running

To set up the development environment and run the project, follow these steps:

### Prerequisites
- Flutter (stable channel)
- mise (task runner and environment manager)

### Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/L4Ph/Novelty.git
   cd Novelty
   ```
2. **Install dependencies:**
   ```bash
   mise run get
   ```
3. **Run code generation:**
   ```bash
   mise run codegen
   ```

### Running the Application
```bash
mise run run
```

## Agent skills

### Issue tracker

Issues and PRDs live as GitHub issues in this repo, operated via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.