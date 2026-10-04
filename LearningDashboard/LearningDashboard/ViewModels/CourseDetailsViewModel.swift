import Foundation
import Combine

@MainActor
final class CourseDetailsViewModel: ObservableObject {
    @Published private(set) var course: Course
    @Published var errorMessage: String?

    private let repository: CourseRepository

    init(course: Course, repository: CourseRepository) {
        self.course = course
        self.repository = repository
    }

    func markCompleted(lesson: Lesson) {
        guard !lesson.isCompleted else { return }
        do {
            let courses: [Course] = try repository.updateLesson(courseID: course.id, lessonID: lesson.id)
            if let updated = courses.first(where: { $0.id == course.id }) {
                course = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
