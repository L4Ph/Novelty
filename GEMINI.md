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
- FVM (Flutter Version Management)

### Setup
1. **Clone the repository:**
   ```bash
   git clone https://github.com/L4Ph/Novelty.git
   cd Novelty
   ```
2. **Install the Flutter SDK using FVM:**
   ```bash
   fvm install
   ```
3. **Install dependencies:**
   ```bash
   fvm flutter pub get
   ```
4. **Run code generation:**
   ```bash
   fvm dart run build_runner build -d
   ```

### Running the Application
```bash
fvm flutter run
```

## Development Conventions

The project follows standard Flutter and Dart conventions. The code is well-structured, with a clear separation of concerns. The use of Riverpod for state management and GoRouter for navigation indicates a modern and scalable architecture. The project also includes a comprehensive set of dependencies, managed using `pubspec.yaml`, and uses `build_runner` for code generation, which is common in modern Dart projects.

First, **plan your work, write tests (following the TDD cycle of Red, Green, Refactor), and continuously validate your plan** during implementation.
**Commit after completing each phase** of the work as outlined in your plan.
Finally, **ensure zero Lint issues** (including those classified as `info`) at all times.

## Language
Please comment on the code and any final communication with me in Japanese.
Please keep things that don't require an intermediary, such as your own thoughts and planning, in English.