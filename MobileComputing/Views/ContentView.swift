/*
    ContentView handles which View is displayed to the user
    The PreviewProvider is accessed through this file.
*/

/*
    Since this application is built with SwiftUI, no ViewControllers are needed,
    although it is possible to mix them using UIKit with SwiftUI.
    
    @State / @Binding declarators take over the role of the ViewModels,
    providing a subscription mechanism, refreshing the UI when needed.
 
    @State declarates a single source of truth for the variable,
    that can be potentially be accessed from anywhere in the app.
    To do so, it has to be included as a parameter in a View call
    @Binding can be used to access and change a variable initialized in a parent view
    in a given child view. (In other words: Binding tells the app,
    that the value for the variable is stored elsewhere.)
    @StateObject declarates a single source of truth for an ObservableObject.
    This can be set as an environmentVariable to pass it to every child view
    and their children.
    @EnvironmentObject initializes the @StateObject in the Child View.
    (only necessary for Views that want to access it, no must to init)
*/

import SwiftUI

struct ContentView: View {
    
    @StateObject private var data = DataManager()
    
    var body: some View {
        VStack {
            
            // --------------------------------------------------------- TITLE SCREEN
            if data.showView == "Title" {
                TitleScreenView()
                
            // --------------------------------------------------------- PLAY / MAIN SCREEN
            } else if data.showView == "Play" {
                CharacterView()
                
            // --------------------------------------------------------- SETTINGS SCREEN
            } else if data.showView == "Settings" {
                SettingView()
                
            // --------------------------------------------------------- DUNGEON SCREEN
            } else if data.showView == "Dungeon" {
                DungeonView()
                
            // --------------------------------------------------------- MULTIPLAYER SCREEN
            } else if data.showView == "Multiplayer" {
                MultiplayerView()
            
            // --------------------------------------------------------- INVENTORY SCREEN
            } else if data.showView == "Inventory" {
                InventoryView()
            
            // --------------------------------------------------------- TRAINING SCREEN
            } else if data.showView == "Training" {
                TrainingView()
                
            // --------------------------------------------------------- CREATE PLAYER SCREEN
            } else if data.showView == "Create" {
                CreatePlayerView()
                
            // --------------------------------------------------------- CREATE PLAYER SCREEN
            } else if data.showView == "Fight" {
                FightView()
            }
        }
        .environmentObject(data)        // sets "data" as environmentObject for all Child-Views
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
