/*
    Structure for PlayerStats
*/

import Foundation

struct Player: Codable, Identifiable {
    var id: Int
    var username: String
    var charClass: String
    var sprite: String
    var sta: Double
    var def: Double
    var dex: Double
}


/*
    Structure for Opponents
 
    This struct is only used to generate Opponents for the demoUsers.
    A real Multipeer Connection would need a broader struct to meet the needed
    criteria for a fight (e.g. stats, class, ...)
*/
struct Opponent: Codable, Identifiable {
    var id: Int
    var username: String
    var sprite: String
}
