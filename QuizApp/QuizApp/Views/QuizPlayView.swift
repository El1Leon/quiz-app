import SwiftUI
import Shared

struct QuizPlayView: View {
    @Environment(QuizStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let quiz: Quiz

    @State private var currentIndex = 0
    @State private var answers: [Int?]
    @State private var finishedScore: Int?

    init(quiz: Quiz) {
        self.quiz = quiz
        _answers = State(initialValue: Array(repeating: nil, count: quiz.questions.count))
    }

    private var currentQuestion: Question { quiz.questions[currentIndex] }
    private var isLastQuestion: Bool { currentIndex == quiz.questions.count - 1 }

    var body: some View {
        NavigationStack {
            Group {
                if let score = finishedScore {
                    QuizResultView(quiz: quiz, score: score, total: quiz.questions.count) {
                        dismiss()
                    } onRetake: {
                        currentIndex = 0
                        answers = Array(repeating: nil, count: quiz.questions.count)
                        finishedScore = nil
                    }
                } else {
                    questionBody
                }
            }
            .navigationTitle(quiz.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var questionBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Question \(currentIndex + 1) of \(quiz.questions.count)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(currentQuestion.text)
                .font(.title2.bold())

            ForEach(currentQuestion.choices.indices, id: \.self) { index in
                Button {
                    answers[currentIndex] = index
                } label: {
                    HStack {
                        Text(currentQuestion.choices[index])
                        Spacer()
                        if answers[currentIndex] == index {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .padding()
                    .background(answers[currentIndex] == index ? Color.accentColor.opacity(0.15) : Color.secondary.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }

            Spacer()

            Button(isLastQuestion ? "Finish" : "Next") {
                if isLastQuestion {
                    let score = quiz.score(for: answers)
                    store.recordAttempt(QuizAttempt(quizID: quiz.id, score: score, total: quiz.questions.count))
                    finishedScore = score
                } else {
                    currentIndex += 1
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(answers[currentIndex] == nil)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    QuizPlayView(quiz: Quiz(
        title: "Sample",
        questions: [Question(text: "2 + 2?", choices: ["3", "4"], correctChoiceIndex: 1)]
    ))
    .environment(QuizStore())
}
