import SwiftUI

struct CourseDetailsView: View {
    @StateObject private var viewModel: CourseDetailsViewModel

    init(course: Course, repository: CourseRepository) {
        _viewModel = StateObject(wrappedValue: CourseDetailsViewModel(course: course, repository: repository))
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.course.title)
                        .font(.title2.weight(.bold))
                    Text("Current progress: \(viewModel.course.progress)%")
                        .foregroundStyle(.secondary)
                    ProgressView(value: Double(viewModel.course.progress), total: 100)
                }
                .padding(.vertical, 6)
            }

            Section("Lessons") {
                ForEach(viewModel.course.lessonItems) { lesson in
                    Button {
                        viewModel.markCompleted(lesson: lesson)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(lesson.isCompleted ? .green : .secondary)
                            Text(lesson.title)
                                .foregroundStyle(.primary)
                            Spacer()
                            Text(lesson.isCompleted ? "Completed" : "Pending")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .disabled(lesson.isCompleted)
                }
            }

            if let error = viewModel.errorMessage {
                Section {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
