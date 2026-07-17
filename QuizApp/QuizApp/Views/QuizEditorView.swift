import SwiftUI
import Shared

struct QuizEditorView: View {
    @Environment(QuizStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    let existingQuiz: Quiz?

    @State private var id: UUID
    @State private var title: String
    @State private var createdAt: Date
    @State private var questions: [Question]

    init(quiz: Quiz?) {
        existingQuiz = quiz
        _id = State(initialValue: quiz?.id ?? UUID())
        _title = State(initialValue: quiz?.title ?? "")
        _createdAt = State(initialValue: quiz?.createdAt ?? Date())
        _questions = State(initialValue: quiz?.questions ?? [])
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !questions.isEmpty
            && questions.allSatisfy { question in
                !question.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && question.choices.count >= 2
                    && question.choices.allSatisfy { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    && question.choices.indices.contains(question.correctChoiceIndex)
            }
    }

    var body: some View {
        Form {
            Section("Title") {
                TextField("Quiz Title", text: $title)
            }

            ForEach($questions) { $question in
                Section {
                    QuestionEditorRow(question: $question)
                } header: {
                    HStack {
                        Text("Question \((questions.firstIndex(where: { $0.id == question.id }) ?? 0) + 1)")
                        Spacer()
                        Button(role: .destructive) {
                            questions.removeAll { $0.id == question.id }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }

            Section {
                Button {
                    questions.append(Question(text: "", choices: ["", ""], correctChoiceIndex: 0))
                } label: {
                    Label("Add Question", systemImage: "plus")
                }
            }
        }
        .navigationTitle(existingQuiz == nil ? "New Quiz" : "Edit Quiz")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let quiz = Quiz(id: id, title: title, questions: questions, createdAt: createdAt)
                    if existingQuiz == nil {
                        store.addQuiz(quiz)
                    } else {
                        store.updateQuiz(quiz)
                    }
                    dismiss()
                }
                .disabled(!canSave)
            }
        }
    }
}

private struct QuestionEditorRow: View {
    @Binding var question: Question

    var body: some View {
        TextField("Question text", text: $question.text)

        ForEach(question.choices.indices, id: \.self) { index in
            HStack {
                Button {
                    question.correctChoiceIndex = index
                } label: {
                    Image(systemName: question.correctChoiceIndex == index ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(question.correctChoiceIndex == index ? .green : .secondary)
                }
                .buttonStyle(.plain)

                TextField("Choice \(index + 1)", text: Binding(
                    get: { question.choices[index] },
                    set: { question.choices[index] = $0 }
                ))

                if question.choices.count > 2 {
                    Button(role: .destructive) {
                        question.choices.remove(at: index)
                        if question.correctChoiceIndex >= question.choices.count {
                            question.correctChoiceIndex = question.choices.count - 1
                        } else if question.correctChoiceIndex > index {
                            question.correctChoiceIndex -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .buttonStyle(.plain)
                }
            }
        }

        if question.choices.count < 4 {
            Button {
                question.choices.append("")
            } label: {
                Label("Add Choice", systemImage: "plus")
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuizEditorView(quiz: nil)
    }
    .environment(QuizStore())
}
