import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapShotTests: XCTestCase {
    
    func testTrackersViewControllerLightSnapshot()  {
        let viewController = TrackersViewController()
        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    func testTrackersViewControllerDarkSnapshot() {
        let viewController = TrackersViewController()
        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
