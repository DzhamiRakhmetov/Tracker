
import Foundation
// MARK: - Errors

enum TrackerStoreError: Error {
    case invalidTrackerID
    case invalidTrackerName
    case invalidTrackerColor
    case invalidTrackerEmoji
    case invalidTrackerScheduleInt
    case hexDeserializationError
}
