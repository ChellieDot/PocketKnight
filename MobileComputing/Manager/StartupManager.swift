/*
    While the StartupManager Class is mostly used to fetch data during the Start of the App for DataManager,
    the CreatePlayerView will also access this class to ensure that all the needed data is loaded if:
    - this is the first time the app has been started
    - AND a new character is created
    This is crucial, since before actually creating a player, certain DB queries have not been called yet.
 
    StartupManager needs access to:
    * HealthStore
    * DBStore
 
    StartupManager is only used to FETCH data, not alter it.
    It also provides a toggle for the HealthStore requests to the user
*/

class StartupManager {
    
    private var healthStore: HealthStore?
    private var database = DBStore.shared
    
    init() {
        healthStore = HealthStore()
    }
    
    func loadsprite() -> String {
        let sprite = database.checkCharSprite()
        return sprite
    }
    
    func getUsername() -> String {
        let userName = database.checkUsername()
        return userName
    }
    
    func loadInventory() -> [Item] {
        let inventory = database.checkItems()
        return inventory
    }
    
    func loadEquippedItems() -> [Equipped] {
        let equippedItems = database.checkItemSlots()
        return equippedItems
    }
    
    func getAttributes() -> [Double] {
        let attributes = database.checkAttributes()
        return attributes
    }
    
    func checkIfPlayerExists() -> Bool {
        return database.checkExistenceOfPlayer()
    }
    
    func checkActiveAdventure() -> String {
        let adventureType = database.fetchActiveAdventure()
        return adventureType[0]
    }
    
    func toggleHealthRequest() {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                // possibly more logic in here
            }
        }
    }
}
