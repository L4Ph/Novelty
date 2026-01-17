# Project Overview

This is a Flutter project called "Novelty," a cross-platform novel viewer for the website "小説家になろう" (Let's Become a Novelist). The application is designed to provide an optimal reading experience, built from the ground up with a focus on simplicity and modern features. It is a client application for the "小説家になろう" website and is developed using the Flutter framework, ensuring a consistent and comfortable user experience across iOS, Android, and desktop platforms (Windows, macOS, Linux).

The project uses a modern and robust technology stack, including:
- **Framework:** Flutter
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Database:** Drift (SQLite)
- **API Client:** Dio
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

## Development Conventions

First, create a work plan and do not start implementation until the plan is approved.
Then, follow t_wada's TDD cycle to create tests and continuously verify the plan during implementation.
Once each phase is completed, confirm that there are always zero Lint issues (including those classified as `info`).
After that, you will be asked whether you want to commit.
If approved, write a commit message in Japanese and commit.
When interacting with the user, please provide final responses, implementation plans, and walkthroughs in Japanese to ensure clear communication.

## Language

- **User Interaction:** Please use Japanese for all final communication, including plans, progress updates, and final answers. Ensure the Japanese is natural, polite, and easy to understand.
- **Code Comments:** Please write code comments in Japanese.
- **Internal Reasoning:** You may keep things that don't require user visibility, such as your own thoughts, planning drafts, and internal logs, in English to optimize token usage.