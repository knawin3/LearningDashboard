import XCTest
@testable import LearningDashboard

final class CourseProgressCalculatorTests: XCTestCase {
    func testProgressCalculationClampsCompletedLessonsAndReturnsPercentage() {
        XCTAssertEqual(CourseProgressCalculator.percentage(completed: 2, total: 4), 50)
        XCTAssertEqual(CourseProgressCalculator.percentage(completed: 10, total: 4), 100)
        XCTAssertEqual(CourseProgressCalculator.percentage(completed: -1, total: 4), 0)
        XCTAssertEqual(CourseProgressCalculator.percentage(completed: 1, total: 0), 0)
    }
}
