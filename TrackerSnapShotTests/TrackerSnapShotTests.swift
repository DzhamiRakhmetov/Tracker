//
//  TrackerSnapShotTests.swift
//  TrackerSnapShotTests
//
//  Created by Dzhami on 16.08.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerSnapShotTests: XCTestCase {

    func testTrackersViewController() {
        let viewController = TrackersViewController()
        assertSnapshot(matching: viewController, as: .image)
    }
}
