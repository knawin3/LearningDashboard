import Foundation
import Combine

@MainActor
final class CourseRepository: ObservableObject {
    private let api: CourseAPI
    private let cache: CourseCache
    private(set) var lastFetchUsedCache = false

    init(api: CourseAPI, cache: CourseCache) {
        self.api = api
        self.cache = cache
    }

    func setOfflineSimulation(_ enabled: Bool) {
        (api as? MockCourseAPI)?.simulateOffline = enabled
    }

    func fetchCourses() async throws -> [Course] {
        do {
            let courses = try await api.fetchCourses()
            try cache.save(courses)
            return courses
        } catch {
            if let cached: [Course] = try? cache.load() {
                lastFetchUsedCache = true
                return cached
            }
            throw error
        }
    }
//    func fetchCourses() async throws -> [Course] {
//        lastFetchUsedCache = false
//        do {
//            let remote = try await api.fetchCourses()
//            try cache.save(remote)
//            return remote
//        } catch {
//            if let cached = try? cache.load(), let cached {
//                lastFetchUsedCache = true
//                return cached
//            }
//            throw error
//        }
//    }

    func updateLesson(courseID: Int, lessonID: Int) throws -> [Course] {
        guard var courses = try cache.load() else {
            throw APIError.invalidResponse
        }
        guard let courseIndex = courses.firstIndex(where: { $0.id == courseID }),
              let lessonIndex = courses[courseIndex].lessonItems.firstIndex(where: { $0.id == lessonID }) else {
            throw APIError.invalidResponse
        }

        courses[courseIndex].lessonItems[lessonIndex].isCompleted = true
        courses[courseIndex].progress = CourseProgressCalculator.percentage(for: courses[courseIndex].lessonItems)
        try cache.save(courses)
        return courses
    }

    func cachedCourses() throws -> [Course]? {
        try cache.load()
    }
}
