import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    var isValid: Bool {
        email.contains("@") && email.contains(".") && password.count >= 6
    }

    func login() async -> Bool {
        errorMessage = nil
        guard isValid else {
            errorMessage = "Enter a valid email and a password with at least 6 characters."
            return false
        }

        isLoading = true
        defer { isLoading = false }
        try? await Task.sleep(for: .milliseconds(600))
        return true
    }
}
