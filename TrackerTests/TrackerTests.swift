import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testTrackersViewController() {
        let vc = TrackersViewController()
        assertSnapshot(of: vc, as: .image)
    }
 
}
