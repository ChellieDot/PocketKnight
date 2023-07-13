/*
    This class will serve as a way to check, update or remove data from the database,
    as well as handle every kind of logic that is not tied to a View.
    It is mostly called for handling logic for dungeons and training.
    
    It handles communication with
    * DBStore
    * HealthStore
*/

import Foundation
import HealthKit

class AdventureManager {
    
    private var healthStore: HealthStore?       // optional var, in case HealthKit is not available
    private var database = DBStore.shared
    private let dateFormatter = DateFormatter()
    
    init() {
        healthStore = HealthStore()
    }
    
    func calculateAdventureSteps(startSteps: Double, endSteps: Double) -> Double{
        return (endSteps - startSteps)
    }
    
    func startAdventure(adventureType: String) {
        let date = Date()                                       // create a date object from today
        dateFormatter.dateFormat = "YYYY-MM-dd"                 // set Formatter to use the desired format
        
        // date in String can be used to forward to the database.
        // the format is based on a shortened ISO-format and will be fully expanded in HealthStore
        // to prevent difficulties in formatting (like timezones)
        let dateInString = dateFormatter.string(from: date)
        
        healthStore?.fetchDaySteps(chosenDay: dateInString)     // fire query to fetch Steps from HealthStore
        
        // to ensure that the HealthStore Query is completed, the rest of the logic will be fired
        // on a asynchronous thread after 1 second
        // this does not affect the UI, as the UI is not waiting for a return value from startAdventure
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let steps = self.healthStore?.getQueriedSteps() ?? 0
            self.database.createAdventure(aType: adventureType, aDate: dateInString, aStartSteps: steps)
        }
    }
    
    func finishAdventure() -> [String] {
        var rewards: [String] = []
        
        let adventureData = database.fetchActiveAdventure()
        
        healthStore?.fetchDaySteps(chosenDay: adventureData[1])
        
        // While 'startAdventure' uses a asynchronous thread, we wait one second on the main thread
        // before continouing. This has to be done, because we need the final stepCount to generate a reward
        // for the user and return several values to the UI
        do {
            sleep(1)    // wait one second
            let steps = self.healthStore?.getQueriedSteps() ?? 0
            print("Adventure from \(adventureData[1]) finished with \(steps) steps")
            self.database.updateAdventure(aFinishSteps: steps)
            
            let points = self.calculateAdventureSteps(startSteps: Double(adventureData[2]) ?? 0, endSteps: steps)
            rewards.append("You gathered \(Int(points)) Points.")
            
            if (points > 500) {
                if (adventureData[0] == "Dungeon") {
                    let itemIDs = generateItem(points: points)
                    rewards.append(contentsOf: itemIDs)                 // to append a list to a list "contentsOf" is used
                                                                        // to access each item in the second list
                } else {
                    let trainingFocus = adventureData[0].replacingOccurrences(of: "Training ", with: "")    // determine the Training Focus for DBs
                    rewards.append(self.finishTraining(stat: trainingFocus, points: points))
                }
            } else {
                // if the player does not reach the first threshold for rewards, this string will be returned instead.
                rewards = ["You gathered \(Int(points)) Points.", "Try adventuring a little longer next time!"]
            }
        }
        return rewards
    }
    
    func generateItem(points: Double) -> [String] {
        let itemDrops = [0, 0, 0, 0,        // This Array contains item ID's
                         1, 1, 1,           // according to the items dropRate,
                         2, 2,              // some items appear "more often"
                         3,                 // than others.
                         4, 4, 4, 4,
                         5, 5, 5,           // since the item selection itself
                         6, 6,              // is not mutable, we decided to hardcode
                         7,                 // this array instead of generating it
                         8, 8, 8, 8,        // for every time this function is called
                         9, 9, 9,
                         10, 10,
                         11]
        
        // randomly select itemIDs from Array
        let itemAmount = Int(points / 500)
        var generatedIDs: [Int] = []
        
        for _ in 1...itemAmount {
            generatedIDs.append(itemDrops.randomElement()!)
        }
        
        // update database to increase each selected itemID by 1
        for item in generatedIDs {
            database.updateItem(itemID: item, quantityDifference: 1)
        }
        
        // fetch item names for every generated Item and generate a String Array for the feedback
        let inventory = database.checkItems()
        var items: [String: Int] = [:]
        var rewards: [String] = []
        
        for i in generatedIDs {
            // add item name as key to the Array and add the count of the item to it
            items[inventory[i].name] = (items[inventory[i].name] ?? 0) + 1
        }
        
        for (key, value) in items {
            rewards.append("Found \(value)x \(key)")
        }
        
        // Solution in Lines 116-123 based on this thread:
        // https://stackoverflow.com/questions/30545518/how-to-count-occurrences-of-an-element-in-a-swift-array
        
        return rewards
    }
    
    func finishTraining(stat: String, points: Double) -> String {
        let statIncrease = points / 100
        
        database.updatePlayerStats(stat: stat, value: statIncrease)
        
        return "\(stat) increased by \(Int(statIncrease)) Points!"
    }
    
    func createUser(username: String, playerClass: String) {
        database.createPlayer(userName: username, chosenClass: playerClass)     // create actual Player in DB
        database.insertItems()                                                  // Insert Items from JSON to DB
        database.createItemSlots()                                              // create ItemSlots with placeholder
    }
    
    func resetGame() {
        // keep the tables, but remove every row from every table
        database.deletePlayer()
        database.deleteItems()
        database.deleteAdventures()
        database.deleteItemSlots()
    }
    
    func useItem(id: Int, sprite: String) {
        // decreases the items count by 1 (identified through its id)
        // sets the right equipment-slot to its value instead
        database.updateItem(itemID: id, quantityDifference: -1)
        database.updateItemSlot(itemID: id, itemSprite: sprite)
    }
    
    func getItem(id: Int) {
        // increases the items count by 1 (identified through its id)
        database.updateItem(itemID: id, quantityDifference: 1)
    }
    
    func clearSlot(id: Int) {
        database.updateItemSlot(itemID: id, itemSprite: "b_blank")
    }
    
}
