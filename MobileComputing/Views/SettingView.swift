import Foundation
import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var data: DataManager
    
    private let adventureManager = AdventureManager()
    
    func back() {
        data.showView = data.lastView
    }
    
    func title() {
        data.showView = "Title"
    }
    
    // deleting the player will not update every data found in DataManager
    // only username and onAdventure have an potential impact on the title screen
    // every other aspect is handled either in adventureManager or
    // during the creation of a new player
    func deletePlayer() {
        data.username = ""
        data.onAdventure = ""
        adventureManager.resetGame()
        title()
    }
    
    var body: some View {
        
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_world")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
            
            // --------------------------------------------------------- CONTENT
            VStack {
                
                Text("SETTINGS")
                    .font(.custom("PaytoneOne-Regular", size: 36))
                    .foregroundColor(.white)

                Button {
                    deletePlayer()
                } label: {
                    Image("b_reset_char")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 275)
                }
                
                Button { back() } label: {
                    Image("b_back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 275)
                }
                
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}
