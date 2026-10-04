import Foundation
import Combine

@MainActor
final class AppDependencies {
    static let shared = AppDependencies()

    // Make repository lazy so it initializes only when first used,
    // avoiding potential main-thread work at app launch.
    lazy var repository: CourseRepository = {
        #if DEBUG
        print("[AppDependencies] Initializing CourseRepository (lazy)")
        #endif
        return CourseRepository(api: MockCourseAPI(), cache: CourseCache())
    }()

    // Default private initializer keeps the singleton pattern intact.
    private init() { }

    // Internal convenience initializer to allow injection in tests/previews if needed.
    // Note: This does not affect the singleton instance unless used explicitly.
    init(repository: CourseRepository) {
        self.repository = repository
    }
}
