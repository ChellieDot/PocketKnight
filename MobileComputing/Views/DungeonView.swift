import Foundation
import SwiftUI
import HealthKit

struct DungeonView: View {
    
    @EnvironmentObject var data: DataManager
    
    @State private var showReward = false
    @State private var rewards: [String] = []       // rewards needs to be @State to display in RewardsView
    
    private var adventureManager: AdventureManager
    
    init() {
        adventureManager = AdventureManager()
    }
    
    func close() {
        data.showView = "Play"
    }
    
    func startDungeon() {
        adventureManager.startAdventure(adventureType: "Dungeon")
        data.onAdventure = "Dungeon"
    }
    
    func stopDungeon() {
        rewards = adventureManager.finishAdventure()
        showReward = true
        data.onAdventure = ""
    }
    
    var body: some View {
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_dungeon")
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
                        Text("DUNGEON")
                            .font(.custom("PaytoneOne-Regular", size: 36))
                            .foregroundColor(.white)
                            .padding(.top, 25)
                        
                        if (data.onAdventure == "") {
                            Text("Enter a dungeon to find valuable loot! \n\n* Your character will come back at midnight the latest \n* 1 Reward / 500 Steps")
                                .font(.custom("PaytoneOne-Regular", size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 1)
                        } else if (data.onAdventure != "") {
                            Text("You are currently absolving a \(data.onAdventure)")
                                .font(.custom("PaytoneOne-Regular", size: 18))
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
                    
                    // Right side of screen with "Enter" Button
                    VStack {
                        if (data.onAdventure == "") {                    // Button for entering Dungeon
                            Button {
                                startDungeon()
                            } label: {
                                Image("b_enter")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: metrics.size.width * 0.35)
                            }
                        } else if (data.onAdventure == "Dungeon") {      // Button for exiting Dungeon
                            Button {
                                stopDungeon()
                            } label: {
                                Image("b_leave")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: metrics.size.width * 0.35)
                            }
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
            
            // --------------------------------------------------------- REWARD SUBVIEW
            if (showReward) {
                RewardView(showReward: $showReward, rewards: $rewards)
            }
        }
    }
}
