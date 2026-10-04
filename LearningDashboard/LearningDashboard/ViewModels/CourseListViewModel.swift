import Foundation
import Combine

@MainActor
final class CourseListViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Course])
        case empty
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    @Published private(set) var isRefreshing = false
    @Published private(set) var showingCachedData = false

    private let repository: CourseRepository

    init(repository: CourseRepository) {
        self.repository = repository
    }

    func load() async {
        state = .loading
        showingCachedData = false
        do {
            let courses = try await repository.fetchCourses()
            if courses.isEmpty {
                state = .empty
            } else {
                state = .loaded(courses)
                showingCachedData = repository.lastFetchUsedCache
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    func refresh() async {
        isRefreshing = true
        defer { isRefreshing = false }
        do {
            let courses = try await repository.fetchCourses()
            state = courses.isEmpty ? .empty : .loaded(courses)
            showingCachedData = repository.lastFetchUsedCache
        } catch {
            if case .loaded = state {
                showingCachedData = true
            } else {
                state = .failed(error.localizedDescription)
            }
        }
    }

    func setOfflineSimulation(_ enabled: Bool) {
        repository.setOfflineSimulation(enabled)
    }
}
