import Foundation
import Shared
import Observation

@Observable
final class QuizStore {
    private(set) var quizzes: [Quiz] = []
    private(set) var attempts: [QuizAttempt] = []

    private let quizzesURL: URL
    private let attemptsURL: URL

    init() {
        let supportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("QuizApp", isDirectory: true)
        try? FileManager.default.createDirectory(at: supportDir, withIntermediateDirectories: true)

        quizzesURL = supportDir.appendingPathComponent("quizzes.json")
        attemptsURL = supportDir.appendingPathComponent("attempts.json")

        load()
    }

    func addQuiz(_ quiz: Quiz) {
        quizzes.append(quiz)
        save()
    }

    func updateQuiz(_ quiz: Quiz) {
        guard let index = quizzes.firstIndex(where: { $0.id == quiz.id }) else { return }
        quizzes[index] = quiz
        save()
    }

    func deleteQuiz(_ quiz: Quiz) {
        quizzes.removeAll { $0.id == quiz.id }
        attempts.removeAll { $0.quizID == quiz.id }
        save()
    }

    func deleteQuizzes(at offsets: IndexSet) {
        let toDelete = offsets.map { quizzes[$0] }
        toDelete.forEach { quiz in
            attempts.removeAll { $0.quizID == quiz.id }
        }
        for index in offsets.sorted(by: >) {
            quizzes.remove(at: index)
        }
        save()
    }

    func recordAttempt(_ attempt: QuizAttempt) {
        attempts.append(attempt)
        save()
    }

    func attempts(for quiz: Quiz) -> [QuizAttempt] {
        attempts.filter { $0.quizID == quiz.id }.sorted { $0.date > $1.date }
    }

    private func load() {
        if let data = try? Data(contentsOf: quizzesURL),
           let decoded = try? JSONDecoder().decode([Quiz].self, from: data) {
            quizzes = decoded
        }
        if let data = try? Data(contentsOf: attemptsURL),
           let decoded = try? JSONDecoder().decode([QuizAttempt].self, from: data) {
            attempts = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(quizzes) {
            try? data.write(to: quizzesURL, options: .atomic)
        }
        if let data = try? JSONEncoder().encode(attempts) {
            try? data.write(to: attemptsURL, options: .atomic)
        }
    }
}
