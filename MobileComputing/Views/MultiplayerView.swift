/*
    The MultiplayerView only displays the correct UI to simulate multipeer behaviour
*/

import Foundation
import SwiftUI

struct MultiplayerView: View {
    
    @EnvironmentObject var data: DataManager
    
    @State var showAcceptView = false
    @State var switchToFight = false
    @State var opponentName = ""
    @State var opponentSprite = ""
    @State var showOpponents = false
    
    private var adventureManager: AdventureManager?
    private let demoUser: [Opponent] = [Opponent(id: 0, username: "CodeFoo", sprite: "sprites_PLD"),
                                Opponent(id: 1, username: "PhilThePaladin", sprite: "sprites_ROG"),
                                Opponent(id: 2, username: "RollTheRick", sprite: "sprites_SMG"),
                                Opponent(id: 3, username: "Buddle", sprite: "sprites_PLD"),
                                Opponent(id: 4, username: "Capybara", sprite: "sprites_ROG")]
    
    init() {
        adventureManager = AdventureManager()
    }
    
    func close() {
        showOpponents = false
        data.showView = "Play"
    }
    
    func searchForOpponents() {
        // As a placeholder, this function only sets showOpponents to true
        // In a real-life scenario, this function would invoke the multipeer search for opponents
        // and display those devices instead.
        showOpponents = true
    }
    
    func fightOpponent(opponent: Opponent) {
        data.opponent = opponent
        showAcceptView = true
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
                        Text("MULTIPLAYER FIGHT")
                            .font(.custom("PaytoneOne-Regular", size: 36))
                            .foregroundColor(.white)
                            .padding(.top, 25)
                        
                        if showOpponents {
                            ForEach(demoUser) { user in
                                Button {
                                    fightOpponent(opponent: user)
                                } label: {
                                    Text(user.username)
                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding(.top, 1)
                                }
                            }
                        } else {
                            Text("Nobodys here...")
                                .font(.custom("PaytoneOne-Regular", size: 30))
                                .foregroundColor(.white)
                                .padding(.top, 1)
                        }
                        
                    }
                    .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.60), minHeight: 0, maxHeight: .infinity, alignment: .top)
                    .background(
                        Image("Inv_BG")
                            .resizable()
                    )
                    .padding(.top)
                    
                    // Right side of screen with "Find Enemy" Button
                    VStack {
                        Button {
                            searchForOpponents()
                        } label: {
                            Image("b_find_enem")
                                .resizable()
                                .scaledToFit()
                                .frame(width: metrics.size.width * 0.35)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.40), minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                }
            }
            
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
            
            // --------------------------------------------------------- ACCEPT FIGHT SUBVIEW
            if (showAcceptView) {
                AcceptFightView(showAcceptView: $showAcceptView)
            }
        }
    }
}
