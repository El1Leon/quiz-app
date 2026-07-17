# Views

SwiftUI views for QuizApp, wired together from `ContentView` via a `NavigationStack`.

## QuizListView

The app's home screen. Lists all saved quizzes with their question count. From here you can:
- Tap **+** to create a new quiz (opens `QuizEditorView`)
- Tap a quiz to take it (opens `QuizPlayView`)
- Swipe a quiz to edit it (opens `QuizEditorView`) or delete it

Shows an empty-state message when no quizzes exist yet.

## QuizEditorView

Create or edit a quiz. Presented as a sheet from `QuizListView`, used for both flows (a `nil` quiz means "new").

- Edit the quiz title
- Add/remove questions
- Each question has editable text and 2–4 answer choices
- Tap a choice's circle icon to mark it as the correct answer
- **Save** is disabled until the title, all questions, and all choices are filled in

## QuizPlayView

Takes the user through a quiz one question at a time. Presented as a sheet from `QuizListView`.

- Shows the current question and its choices
- **Next** advances to the next question once an answer is selected
- On the last question, the button becomes **Finish**, which scores the attempt via `Quiz.score(for:)`, records it in `QuizStore`, and shows `QuizResultView`
- Contains its own `NavigationStack` so it can transition to the result screen without leaving the sheet

## QuizResultView

Shows the final score and percentage after finishing a quiz. Offers:
- **Retake Quiz** — resets `QuizPlayView`'s state and starts over
- **Done** — dismisses back to `QuizListView`

Not presented directly — it's shown inline by `QuizPlayView` once a quiz is finished.
