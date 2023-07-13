/*
    Structure for Items
 
    Doubles as structure for Inventory, since each included Item will be displayed,
    even if the quantity equals 0
 
    * stat: determines, which user stat will be boosted
    * durability: determines, after how many battles the item will be discarded
    * quantity: number of item in user-inventory (start value: 0)
    * dropRate: determines the probability of finding the item in a dungeon
 */

import Foundation

struct Item: Codable, Identifiable {
    var id: Int
    var name: String
    var category: String
    var stat: String
    var durability: Double
    var power: Double
    var quantity: Double
    var dropRate: Double
    var sprite: String
}

/*
    Structure for Equipped Items
*/
struct Equipped: Codable, Identifiable {
    var id: Int
    var turns: Int
    var sprite: String
}
