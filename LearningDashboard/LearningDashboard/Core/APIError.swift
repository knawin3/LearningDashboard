import Foundation

enum APIError: LocalizedError, Equatable {
    case offline
    case invalidResponse
    case unknown

    var errorDescription: String? {
        switch self {
        case .offline:
            return "The service is unavailable. Cached data will be used when possible."
        case .invalidResponse:
            return "The server returned invalid course data."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
