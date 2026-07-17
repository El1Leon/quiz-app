import SwiftUI
import Shared

struct QuizListView: View {
    @Environment(QuizStore.self) private var store
    @State private var isPresentingEditor = false
    @State private var quizToEdit: Quiz?
    @State private var quizToPlay: Quiz?

    var body: some View {
        Group {
            if store.quizzes.isEmpty {
                ContentUnavailableView(
                    "No Quizzes Yet",
                    systemImage: "questionmark.circle",
                    description: Text("Tap + to create your first quiz.")
                )
            } else {
                List {
                    ForEach(store.quizzes) { quiz in
                        Button {
                            quizToPlay = quiz
                        } label: {
                            VStack(alignment: .leading) {
                                Text(quiz.title)
                                    .font(.headline)
                                Text("\(quiz.questions.count) question\(quiz.questions.count == 1 ? "" : "s")")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .swipeActions {
                            Button("Edit") {
                                quizToEdit = quiz
                            }
                            .tint(.blue)
                        }
                    }
                    .onDelete(perform: store.deleteQuizzes)
                }
            }
        }
        .navigationTitle("Quizzes")
        .toolbar {
            ToolbarItem {
                Button {
                    isPresentingEditor = true
                } label: {
                    Label("New Quiz", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isPresentingEditor) {
            QuizEditorView(quiz: nil)
        }
        .sheet(item: $quizToEdit) { quiz in
            QuizEditorView(quiz: quiz)
        }
        .sheet(item: $quizToPlay) { quiz in
            QuizPlayView(quiz: quiz)
        }
    }
}

#Preview {
    NavigationStack {
        QuizListView()
    }
    .environment(QuizStore())
}
