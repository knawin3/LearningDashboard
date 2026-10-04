import Foundation

enum CourseProgressCalculator {
    static func percentage(completed: Int, total: Int) -> Int {
        guard total > 0 else { return 0 }
        let safeCompleted = min(max(completed, 0), total)
        return Int((Double(safeCompleted) / Double(total) * 100).rounded())
    }

    static func percentage(for lessons: [Lesson]) -> Int {
        percentage(completed: lessons.filter(\.isCompleted).count, total: lessons.count)
    }
}
