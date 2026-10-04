import Foundation

final class CourseCache {
    private let fileManager: FileManager
    private let fileURL: URL

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = base.appendingPathComponent("LearningDashboard", isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        self.fileURL = directory.appendingPathComponent("courses-cache.json")
    }

    func save(_ courses: [Course]) throws {
        let data = try JSONEncoder().encode(courses)
        try data.write(to: fileURL, options: .atomic)
    }

    func load() throws -> [Course]? {
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([Course].self, from: data)
    }
}
