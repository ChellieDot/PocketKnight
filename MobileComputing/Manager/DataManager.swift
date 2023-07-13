/*
    The DataManager class comforms to "ObservableObject" and will provide
    all the necessary data Views might need during Runtime.
    StartupManager will provide the initial Data upon startup and Views are able
    to update the Data during runtime and force re-renders of Views
 
    @Published allows the creation of an observable object
    SwiftUI automatically monitors for such changes and will update views that rely on
    that data (Similar to @State -> See ContentView for more information)
*/

import Foundation

class DataManager: ObservableObject {
    
    private var startup = StartupManager()
    
    // showView determines, which View should be displayed at a given time.
    // Default Value upon startup: "Title"
    @Published var username: String = ""
    @Published var showView: String = "Title"
    @Published var lastView: String = "Title"
    @Published var sprite: String = ""
    @Published var onAdventure: String = ""
    @Published var sta: Double = 0
    @Published var def: Double = 0
    @Published var dex: Double = 0
    @Published var inventory: [Item] = []
    @Published var itemSlots: [Equipped] = [Equipped(id: 0, turns: 0, sprite: "b_blank"),  // id 0 for shields
                                            Equipped(id: 1, turns: 0, sprite: "b_blank"),  // id 1 for swords
                                            Equipped(id: 2, turns: 0, sprite: "b_blank")]  // id 2 for boots
    @Published var opponent: Opponent
    
    init() {
        username = startup.getUsername()
        sprite = startup.loadsprite()
        onAdventure = startup.checkActiveAdventure()
        inventory = startup.loadInventory()
        itemSlots = startup.loadEquippedItems()
        let attributes = startup.getAttributes()
        if attributes != [] {
            sta = attributes[0]
            def = attributes[1]
            dex = attributes[2]
        }
        opponent = Opponent(id: 0, username: "", sprite: "")
    }
}
