import SwiftUI
import Shared

struct QuizResultView: View {
    let quiz: Quiz
    let score: Int
    let total: Int
    let onDone: () -> Void
    let onRetake: () -> Void

    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(score) / Double(total) * 100).rounded())
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: percentage >= 70 ? "star.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(percentage >= 70 ? .yellow : .accentColor)

            Text("You scored")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("\(score) / \(total)")
                .font(.largeTitle.bold())

            Text("\(percentage)%")
                .font(.title3)
                .foregroundStyle(.secondary)

            Spacer()

            VStack(spacing: 12) {
                Button("Retake Quiz", action: onRetake)
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                Button("Done", action: onDone)
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    QuizResultView(
        quiz: Quiz(title: "Sample"),
        score: 2,
        total: 3,
        onDone: {},
        onRetake: {}
    )
}
