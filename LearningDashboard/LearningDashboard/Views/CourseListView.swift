import SwiftUI

struct CourseListView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: CourseListViewModel

    init() {
        _viewModel = StateObject(wrappedValue: CourseListViewModel(repository: AppDependencies.shared.repository))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("My Courses")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Logout") { appState.logout() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Toggle("Offline", isOn: Binding(
                            get: { appState.isOfflineSimulationEnabled },
                            set: { value in
                                appState.isOfflineSimulationEnabled = value
                                viewModel.setOfflineSimulation(value)
                            }
                        ))
                        .labelsHidden()
                    }
                }
                .task { await viewModel.load() }
                .refreshable { await viewModel.refresh() }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading courses…")
        case .empty:
            ContentUnavailableView("No Courses", systemImage: "books.vertical", description: Text("There are no courses available right now."))
        case .failed(let message):
            ContentUnavailableView("Couldn’t Load Courses", systemImage: "wifi.exclamationmark", description: Text(message))
                .overlay(alignment: .bottom) {
                    Button("Retry") { Task { await viewModel.load() } }
                        .buttonStyle(.borderedProminent)
                        .padding()
                }
        case .loaded(let courses):
            List(courses) { course in
                NavigationLink {
                    CourseDetailsView(course: course, repository: appState.repository)
                } label: {
                    CourseRow(course: course)
                }
            }
            .overlay(alignment: .top) {
                if viewModel.showingCachedData {
                    Label("Showing cached data", systemImage: "externaldrive")
                        .font(.caption)
                        .padding(8)
                        .background(.thinMaterial, in: Capsule())
                        .padding(.top, 6)
                }
            }
        }
    }
}

private struct CourseRow: View {
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(course.title)
                    .font(.headline)
                Spacer()
                Text("\(course.progress)%")
                    .font(.subheadline.weight(.semibold))
            }
            Text("Instructor: \(course.instructor)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(course.progress), total: 100)
            HStack {
                Text("\(course.lessons) lessons")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Continue")
                    .font(.caption.weight(.semibold))
            }
        }
        .padding(.vertical, 6)
    }
}
