import Foundation

struct Course: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let instructor: String
    var progress: Int
    let lessons: Int
    var lessonItems: [Lesson]

    init(id: Int, title: String, instructor: String, progress: Int, lessons: Int, lessonItems: [Lesson] = []) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessons = lessons
        self.lessonItems = lessonItems
    }
}

struct Lesson: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    var isCompleted: Bool
}
