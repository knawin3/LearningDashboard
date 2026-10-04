import Foundation

protocol CourseAPI {
    func fetchCourses() async throws -> [Course]
}

final class MockCourseAPI: CourseAPI {
    var simulateOffline = false

    func fetchCourses() async throws -> [Course] {
        try await Task.sleep(for: .milliseconds(350))
        if simulateOffline {
            throw APIError.offline
        }

        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json") else {
            throw APIError.invalidResponse
        }

        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode([Course].self, from: data)
            return response
        } catch {
            throw APIError.invalidResponse
        }
    }
}
