/*
    Structure for Potions
 
    Potions have a similiar composition to Items
 */

import Foundation

struct Potion: Codable, Identifiable {
    var id: Int
    var name: String
    var stat: String
    var durability: Double
    var quantity: Double
    var dropRate: Double
    var sprite: String
}
