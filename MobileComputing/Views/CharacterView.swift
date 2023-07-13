import Foundation
import SwiftUI

struct CharacterView: View {
        
    @EnvironmentObject private var data: DataManager
    
    func inventory() {
        data.showView = "Inventory"
    }
    
    func dungeon() {
        data.showView = "Dungeon"
    }
    
    func fight() {
        data.showView = "Multiplayer"
    }
    
    func settings() {
        data.lastView = "Play"
        data.showView = "Settings"
    }
    
    func training() {
        data.showView = "Training"
    }
    
    var body: some View {
        
        // Stack on Z-Axis to determine Background Image first
        // and every other element on top
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
            // Horizontal Stack to Split View in half horizontally
            HStack {
                
                // Left side (experimental)
                VStack(spacing: 30) {
                    
                    Button { dungeon() } label: {
                        Image("b_dungeon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275)
                    }
                    
                    Button { training() } label: {
                        Image("b_training")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275)
                    }
                    
                    Button { fight() } label: {
                        Image("b_fight")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275)
                    }
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,
                       alignment: .leading)
                
                
                // Right Side
                // The users character Sprite doubles as a Button to open the InventoryView
                Button {
                    inventory()
                } label: {
                    Image(data.sprite)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.trailing, 100)
            }
            .padding(.top)
            
            // --------------------------------------------------------- USERNAME
            VStack {
                Text("\n\(data.username)")
                    .font(.custom("PaytoneOne-Regular", size: 30))
                    .foregroundColor(Color("AccentColor_light"))
                    .shadow(color: .black, radius: 2, x: 0, y: 5)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,
                   alignment: .top)
            .padding(.leading, 270)     // padding places username roughly centered above Sprite
            
            // --------------------------------------------------------- SETTINGS BUTTON & STATS
            VStack (alignment: .trailing){
                Button { settings() } label: {
                    Image("b_setting")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                }
                
                Spacer()
                
                Text("STA \(Int(data.sta)) \nDEF \(Int(data.def)) \nDEX \(Int(data.dex))")
                    .font(.custom("PaytoneOne-Regular", size: 28))
                    .foregroundColor(Color.white)
                    .shadow(color: .black, radius: 5, x: 0, y: 5)
                    .multilineTextAlignment(.trailing)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,
                   alignment: .topTrailing)
            .padding(.top)
            .padding(.bottom, 20)
            
        }
    }
}
