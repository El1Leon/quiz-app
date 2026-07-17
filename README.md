# QuizApp

A native SwiftUI quiz app for iOS and macOS. Create your own quizzes, take them, and track your scores.

## Features

- Create quizzes with a title and any number of questions
- Each question supports 2–4 multiple-choice answers
- Take a quiz one question at a time, then see your score and percentage
- Retake a quiz or return to the list when finished
- Edit or delete existing quizzes
- Quizzes and attempt history persist locally between launches
- Runs on both iOS and macOS from a single codebase

## Requirements

- Xcode 16 or later
- iOS 17+ / macOS 14+

## Dependencies

QuizApp uses [`Shared`](https://github.com/El1Leon/Shared), a small Swift package containing the `Quiz`, `Question`, and `QuizAttempt` models and scoring logic. It's wired in as a Swift Package Manager dependency, so Xcode resolves it automatically when you open the project.

## Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/El1Leon/quiz-app.git
   ```
2. Open `QuizApp/QuizApp.xcodeproj` in Xcode.
3. Let Xcode resolve the `Shared` package dependency.
4. Build and run (`Cmd+R`) with either an iOS Simulator or "My Mac" as the destination.

## Project Structure

```
QuizApp/
  QuizApp/
    QuizAppApp.swift     # App entry point
    ContentView.swift    # Root view
    QuizStore.swift      # Persistence and state management
    Views/
      QuizListView.swift    # Browse, create, edit, delete quizzes
      QuizEditorView.swift  # Create/edit a quiz's questions and choices
      QuizPlayView.swift    # Take a quiz
      QuizResultView.swift  # View score after finishing
```

## Built with AI Assistance

This project was built using [Claude Code](https://claude.com/claude-code), Anthropic's AI coding assistant, to demonstrate practical experience working with AI-assisted development workflows.
