/*
    DataLoader reads JSON from the specified files
    (in this case: "items.json")
    and stores the decoded data in a list of the desired Structure
 */

import Foundation

// This load function is only called twice:
// once upon every startup, to load the static entries for Potions in the InventoryView
// the second time only when creating a new character, to fill the inventory with necessary data
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Cannot find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Cannot load \(filename) from main bundle.")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Cannot parse \(filename) as \(T.self): \n(error)")
    }
}
