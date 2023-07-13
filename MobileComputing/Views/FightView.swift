import Foundation
import SwiftUI

struct FightView: View {
    
    @EnvironmentObject var data: DataManager
       
    private var adventureManager: AdventureManager?
    @State private var lifebar: Double = 1
    
    init() {
        adventureManager = AdventureManager()
    }
    
    func close() {
        data.showView = "Play"
    }
    
    func hit() {
        if (lifebar >= 0.2) {
            lifebar -= 0.2
        } else {
            data.showView = "Play"
        }
    }
    
    var body: some View {
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_fight_mirrored")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    )
            
            // --------------------------------------------------------- CONTENT
            // Content is wrapped in GeometryReader to determine size by available space
            // (metrics.size.width * 0.xx) -> xx equals desired percentage of e.g. available width
            GeometryReader { metrics in
                HStack {
                    
                    // left side of Screen
                    VStack {
                        Image(data.sprite + "_back")
                            .resizable()
                            .scaledToFit()
                            .frame(height: (metrics.size.height * 0.8))
                    }
                    .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.50), minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, -30)
                    
                    // Right side of screen with "Find Enemy" Button
                    VStack {
                        Text("\n\(data.opponent.username)")
                            .font(.custom("PaytoneOne-Regular", size: 30))
                            .foregroundColor(Color("AccentColor_light"))
                            .shadow(color: .black, radius: 2, x: 0, y: 5)
                            .padding()
                        
                        Button {
                            hit()
                        } label: {
                            Image(data.opponent.sprite)
                                .resizable()
                                .scaledToFit()
                                .frame(height: metrics.size.height * 0.5)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.40), minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 60)
                }
            }
            
            VStack {
                ProgressView(value: lifebar)
                    .scaleEffect(x: 0.8, y: 4, anchor: .center)
                    .accentColor(Color("AccentColor_light"))
                    .padding()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.top)
            
            
            // --------------------------------------------------------- CLOSE BUTTON
            VStack {
                Button { close() } label: {
                    Image("b_close")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                }
                .padding(.top)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,
                   alignment: .topTrailing)
            
        }
    }
}
