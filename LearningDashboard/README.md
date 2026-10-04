# Learning Dashboard — iOS / SwiftUI

Technical assignment implementation for Xcode 27 using Swift 6 and SwiftUI.

## 1. Architecture
MVVM with a Repository layer. SwiftUI views bind to `@MainActor` view models; `CourseRepository` coordinates the mock API and local cache. This keeps UI state separate from data access and makes business logic (`CourseProgressCalculator`) independently testable.

## 2. Offline Support
The mock API loads course data from bundled JSON. After a successful fetch, `CourseCache` stores the courses as JSON in the app's Application Support directory. If the API fails, the repository automatically returns cached courses. The dashboard identifies cached/offline content. The Offline toggle in the demo intentionally makes the mock API fail so the fallback can be demonstrated reliably.

## 3. Security
In production, authentication/access tokens should be stored in the iOS Keychain, not `UserDefaults`, files, or source code. Tokens should be short-lived, refreshed securely, and never logged. Network traffic should use HTTPS with normal certificate validation.

## 4. Scale — 1M users / hundreds of courses
- Replace mock JSON with a versioned HTTPS API with pagination and incremental sync.
- Add server-side authentication, rate limiting, observability, caching/CDN, and horizontal scaling.
- Use a persistent database/cache strategy (e.g. SQLite/Core Data/SwiftData) with migrations and cache invalidation.
- Add request cancellation, retry/backoff, background refresh, and efficient diff-based updates.
- Add analytics/crash monitoring, automated CI/CD, unit/UI tests, and feature flags.

## 5. Android Equivalent
On Android I would use Kotlin + Jetpack Compose, with the same MVVM/Repository separation. A `ViewModel` would expose `StateFlow`, Retrofit/OkHttp would provide the API, and Room would provide persistent offline caching. Navigation Compose would handle Login → Dashboard → Details.

## Demo
1. Login with any valid email (for example `test@example.com`) and a password of 6+ characters.
2. Open a course and mark a pending lesson completed; progress recalculates and persists to cache.
3. Return to the dashboard.
4. Enable the **Offline** toggle and pull to refresh. The mock API fails and the cached courses remain visible.

## Test
`LearningDashboardTests/CourseProgressCalculatorTests.swift` covers percentage calculation, clamping, and the zero-total case.
