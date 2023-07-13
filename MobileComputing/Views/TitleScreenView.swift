import Foundation
import SwiftUI

struct TitleScreenView: View {
    
    @EnvironmentObject var data: DataManager
    
    private let startup = StartupManager()
    private var activePlayer: Bool
    
    init() {
        activePlayer = startup.checkIfPlayerExists()
        startup.toggleHealthRequest()                   // Toggle the HealthKit request in the Title Screen
    }
    
    func play() {
        data.showView = "Play"
    }
    
    func settings() {
        data.lastView = "Title"
        data.showView = "Settings"
    }
    
    func createPlayer() {
        data.showView = "Create"
    }
    
    var body: some View {
        
        // Stack on Z-Axis to determine Background Image first
        // and every other element on top
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_title")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    )
            
            // --------------------------------------------------------- CONTENT
            // Vertical Stack to place every given element top down
            VStack {
                Image("welcome_to")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500)
                    .shadow(color: .black, radius: 5, x: 0, y: 5)
                    .padding(.bottom, 20)
                
                if (activePlayer) {
                    
                    Button {
                        play()
                    } label: {
                        Image("b_play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275)
                    }
                    
                } else {
                    Button { createPlayer() } label: {
                        Image("b_create")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275)
                    }
                }
                
                Button { settings() } label: {
                    Image("b_settings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 275)
                }
                .padding(.top, 5)
                
            }
        }
    }
}
