/*
    DBStore is a class that encapsulates a SQLite Database connection
    
    Needed Package Dependency: SQLite.swift
    Package Source: https://github.com/stephencelis/SQLite.swift
 
    all database functions declared here use the following code at the beginning:
         guard let database = db else {
             return
         }
    "guard" is similar to "if" in Swift. It is used to verify that conditions
    are met at the start of a function (in this case: var "db" exists and has a value)
    When guard {} fails, it has to return from the function and is not allowed to continue.
*/

import Foundation
import SQLite

class DBStore {
    
    static let DIR_EQUIPABLE_DB = "PocketKnightDB"      // Folder name
    static let STORE_NAME = "pocketknight.sqlite3"      // DB name
    
    static let shared = DBStore()                       // Singleton for DBStore
    private var db: Connection? = nil                   // Connection to local Database
    
    // ----- define constants for database tables -----
    private let playerStats = Table("playerStats")
    private let dbItems = Table("items")
    private let adventures = Table("adventures")
    private let equipped = Table("equipped")
    
    // ----- define constants for table columns -------
    // shared
    private let id = Expression<Int64>("id")
    private let sprite = Expression<String>("sprite")
    
    // for playerStats
    private let username = Expression<String>("username")
    private let charClass = Expression<String>("charClass")
    private let sta = Expression<Double>("sta")          // stamina
    private let def = Expression<Double>("def")          // defense
    private let dex = Expression<Double>("dex")          // dexterity
    
    // for items
    private let name = Expression<String>("name")
    private let category = Expression<String>("category")
    private let stat = Expression<String>("stat")
    private let durability = Expression<Double>("durability")
    private let power = Expression<Double>("power")
    private let quantity = Expression<Double>("quantity")
    private let dropRate = Expression<Double>("dropRate")
    
    // for adventures
    private let active = Expression<Bool>("active")
    private let type = Expression<String>("type")
    private let date = Expression<String>("date")
    private let startedSteps = Expression<Double>("startedSteps")
    private let finishedSteps = Expression<Double?>("finishedSteps")
    
    // for equipped
    private let turns = Expression<Double>("turns")
    // ------------------------------------------------
    
    // initialize database connection
    private init() {
        /*
            define the directory for the database
            default: Application Document Folder of Device
            for Simulators that might be:
            "/Users/user/Library/Developer/CoreSimulator/Devices/ABunchOfNumbers../Documents/"
        */
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            // Append folder for database inside
            let dirPath = docDir.appendingPathComponent(Self.DIR_EQUIPABLE_DB)

            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                // Create database inside the just created folder
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                
                createTables()
                print("SQLiteDataStore init successfull. DB is located at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
    }
    
    // create necessary tables for database
    // if tables already exist, re-creation is skipped
    private func createTables() {
        guard let database = db else {
            return
        }
        do {
            try database.run(playerStats.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(username)
                table.column(charClass)
                table.column(sprite)
                table.column(sta)
                table.column(def)
                table.column(dex)
            })
            
            try database.run(dbItems.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(category)
                table.column(stat)
                table.column(durability)
                table.column(power)
                table.column(quantity)
                table.column(dropRate)
                table.column(sprite)
            })
            
            try database.run(adventures.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(active)
                table.column(type)
                table.column(date)
                table.column(startedSteps)
                table.column(finishedSteps)
            })
            
            try database.run(equipped.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(turns)
                table.column(sprite)
            })
            
            print("Tables initialized...")
        } catch {
            print(error)
        }
    }
    
    // ----------------------------------------------------------------- PLAYERSTATS table actions
    // insert Player Stats into "playerStats" table in database
    func createPlayer(userName: String, chosenClass: String) {

        // base values regardles of chosen class
        var dexterity: Double = 50
        var defense: Double = 50
        var stamina: Double = 50
        var charSprite: String = "sprites_"
               
        guard let database = db else {
            return
        }
        
        // determine base values for chosen character class
        if (chosenClass == "PLD") {             // + def, - str
            defense += 25
            stamina -= 25
            charSprite = charSprite + "PLD"
        } else if (chosenClass == "ROG") {      // + dex, - def
            dexterity += 25
            defense -= 25
            charSprite = charSprite + "ROG"
        } else if (chosenClass == "SMG") {      // + str, - dex
            stamina += 25
            dexterity -= 25
            charSprite = charSprite + "SMG"
        }
        
        do {
            let insert = playerStats.insert(
                id <- 1,                        // since only one user can exist, id is set to 1 regardless
                username <- userName,
                charClass <- chosenClass,
                sprite <- charSprite,
                sta <- stamina,
                def <- defense,
                dex <- dexterity)
            try database.run(insert)
            
            print("Player Created...")
            
        } catch {
            print(error)
        }
    }
    
    func deletePlayer() {
        guard let database = db else {
            return
        }
        
        do {
            try database.run(playerStats.delete())
            print("Player deleted...")
        } catch {
            print(error)
        }
    }
    
    func checkExistenceOfPlayer() -> Bool {
        guard let database = db else {
            return false
        }
        
        do {
            // check, if a player character exists
            // scalar returns an integer value with the count of playerStats entries
            let playerExisting = try database.scalar(playerStats.count)
            if (playerExisting == 1) {
                return true
            } else {
                return false
            }
            
        } catch {
            print(error)
            return false
        }
    }
    
    // returns the Users username
    func checkUsername() -> String {
        guard let database = db else {
            return ""
        }
        
        do {
            if let player = try database.pluck(playerStats) {
                return player[username]
            } else {
                return ""
            }
        } catch {
            print(error)
            return ""
        }
    }
    
    // returns the users sprite
    func checkCharSprite() -> String {
        guard let database = db else {
            return ""
        }
        
        do {
            if let player = try database.pluck(playerStats) {
                return player[sprite]
            } else {
                return ""
            }
        } catch {
            print(error)
            return ""
        }
    }
    
    // returns the users attributes
    func checkAttributes() -> [Double] {
        guard let database = db else {
            return []
        }
        
        do {
            if let player = try database.pluck(playerStats) {
                return [player[sta], player[def], player[dex]]
            } else {
                return []
            }
        } catch {
            print(error)
            return []
        }
    }
    
    // although the last three functions could be merged into one,
    // we kept them separate to keep a good overview
    
    // update the specified stat by the desired value
    func updatePlayerStats(stat: String, value: Double) {
        guard let database = db else {
            return
        }
        
        do {
            let player = playerStats.filter(id == 1)
            
            // determine, which stat was trained and should be updated
            if (stat == "STA") {
                try database.run(player.update(sta += value))
                print("Updated STA")
            } else if (stat == "DEF") {
                try database.run(player.update(def += value))
                print("Updated DEF")
            } else if (stat == "DEX") {
                try database.run(player.update(dex += value))
                print("Updated DEX")
            }
        } catch {
            print(error)
            return
        }
    }
    
    // ----------------------------------------------------------------- ITEMS table actions
    // insert Items from "items.json" into the Items Table
    func insertItems() {
        guard let database = db else {
            return
        }
        
        let jsonItems: [Item] = load("items.json")
        
        for item in jsonItems {
            do {
                let insert = dbItems.insert(
                    id <- Int64(item.id),
                    name <- item.name,
                    category <- item.category,
                    stat <- item.stat,
                    durability <- item.durability,
                    power <- item.power,
                    quantity <- item.quantity,
                    dropRate <- item.dropRate,
                    sprite <- item.sprite)
                try database.run(insert)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteItems() {
        guard let database = db else {
            return
        }
        
        do {
            try database.run(dbItems.delete())
            print("Items deleted...")
        } catch {
            print(error)
        }
    }
    
    // return a list of all items in the database
    // different from items.json, since values like quantity can be altered
    func checkItems() -> [Item] {
        
        var items: [Item] = []
        
        guard let database = db else {
            return []
        }
        
        do {
            for item in try database.prepare(dbItems) {
                items.append(Item(id: Int(item[id]), name: item[name], category: item[category], stat: item[stat], durability: item[durability], power: item[power], quantity: item[quantity], dropRate: item[dropRate], sprite: item[sprite]))
            }
            return items
        } catch {
            print(error)
            return []
        }
    }
    
    // update the quantity of a specified item
    func updateItem(itemID: Int, quantityDifference: Double) {
        guard let database = db else {
            return
        }
        
        do {
            let item = dbItems.filter(id == Int64(itemID))
            try database.run(item.update(quantity += quantityDifference))
            return
        } catch {
            print(error)
            return
        }
    }
    
    
    // ----------------------------------------------------------------- ADVENTURES table actions
    // create a new adventure in the Adventures Table
    func createAdventure(aType: String, aDate: String, aStartSteps: Double) {
        guard let database = db else {
            return
        }
        
        do {
            let insert = adventures.insert(
                active <- true,
                type <- aType,
                date <- aDate,
                startedSteps <- aStartSteps,
                finishedSteps <- 0)
            try database.run(insert)
            
            print("\(aType)-Adventure started on \(aDate) at \(aStartSteps) steps")
        } catch {
            print(error)
        }
    }
    
    // update / finish an adventure and set the finishedSteps to the actual value
    func updateAdventure(aFinishSteps: Double) {
        guard let database = db else {
            return
        }
        
        do {
            let query = adventures.filter(active == true)
            try database.run(query.update(active <- false, finishedSteps <- aFinishSteps))
        } catch {
            print(error)
        }
        return
    }
    
    // look for an active adventure in the database and return desired data
    func fetchActiveAdventure() -> [String] {
        guard let database = db else {
            return [""]
        }
        
        do {
            let query = adventures.filter(active == true)
            if let adventure = try database.pluck(query) {
                return [adventure[type], adventure[date], "\(adventure[startedSteps])"]
            } else {
                return [""]
            }
        } catch {
            print(error)
        }
        
        return [""]
    }
    
    func deleteAdventures() {
        guard let database = db else {
            return
        }
        
        do {
            try database.run(adventures.delete())
            print("Adventures deleted...")
        } catch {
            print(error)
        }
    }
    
    
    // ----------------------------------------------------------------- EQUIPPED table actions
    // create Item slots for the Equipped Table and fill them with a blank value
    func createItemSlots() {
        let itemSlots: [Equipped] = [Equipped(id: 0, turns: 0, sprite: "b_blank"),  // id 0 for shields
                                     Equipped(id: 1, turns: 0, sprite: "b_blank"),  // id 1 for swords
                                     Equipped(id: 2, turns: 0, sprite: "b_blank")]  // id 2 for boots
        
        guard let database = db else {
            return
        }
        
        do {
            for equip in itemSlots {
                let insert = equipped.insert(
                    id <- Int64(equip.id),
                    turns <- Double(equip.turns),
                    sprite <- equip.sprite)
                try database.run(insert)
            }
            print("Item Slots for player created...")
        } catch {
            print(error)
        }
    }
    
    // update a calculated slot with their new sprite
    func updateItemSlot(itemID: Int, itemSprite: String) {
        guard let database = db else {
            return
        }
        
        do {
            if ((0...3).contains(itemID)) {
                let query = equipped.filter(id == 0)
                try database.run(query.update(sprite <- itemSprite))
            } else if ((4...7).contains(itemID)) {
                let query = equipped.filter(id == 1)
                try database.run(query.update(sprite <- itemSprite))
            } else if ((8...11).contains(itemID)) {
                let query = equipped.filter(id == 2)
                try database.run(query.update(sprite <- itemSprite))
            }
        } catch {
            print(error)
        }
        return
    }
    
    // fetch all equipped items and return them to the Manager-instances
    func checkItemSlots() -> [Equipped] {
        var equippedItems: [Equipped] = []
        
        guard let database = db else {
            return []
        }
        
        do {
            for itemSlot in try database.prepare(equipped) {
                equippedItems.append(Equipped(id: Int(itemSlot[id]), turns: Int(itemSlot[turns]), sprite: itemSlot[sprite]))
            }
            return equippedItems
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteItemSlots() {
        guard let database = db else {
            return
        }
        
        do {
            try database.run(equipped.delete())
            print("Equipped Items deleted...")
        } catch {
            print(error)
        }
    }
    
}
