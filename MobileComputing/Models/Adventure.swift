/*
    Structure for Player-Adventures
 
    Either Dungeon visits or Training sessions.
    Each adventure will be recorded in the database and will last until
    the end of the day at most.
    This is due to the way Stepcounts can be collected from HealthKit
    (only current data or collective Data from specific Dates can be queried)
*/

import Foundation

struct Adventure: Codable, Identifiable {
    var id: Int
    var active: Bool
    var type: String
    var date: String
    var startedSteps: Double
    var finishedSteps: Double?
}
