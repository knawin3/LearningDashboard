import SwiftUI
import Combine

@main
struct LearningDashboardApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isOfflineSimulationEnabled = false

    let repository: CourseRepository

    init() {
        self.repository = AppDependencies.shared.repository
    }

    func logout() {
        isAuthenticated = false
    }
}
