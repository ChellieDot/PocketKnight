import Foundation
import SwiftUI

struct TrainingView: View {
    
    @EnvironmentObject private var data: DataManager
    
    private var adventureManager: AdventureManager?
    
    @State private var showReward = false
    @State private var trainingFocus = ""
    @State private var rewards: [String] = []
    
    
    init() {
        adventureManager = AdventureManager()
    }
    
    func close() {
        data.showView = "Play"
    }
    
    func startTraining() {
        adventureManager?.startAdventure(adventureType: ("Training " + trainingFocus))
        data.onAdventure = "Training " + trainingFocus
    }
    
    // stopTraining will finish the started adventure, wait for rewards, or rather the to be displayed values
    // and finally reset the trainingFocus and onAdventure values for the runtime
    func stopTraining() {
        rewards = (adventureManager?.finishAdventure())!
        showReward = true
        trainingFocus = ""
        data.onAdventure = ""
    }
    
    var body: some View {
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_training")
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
                        Text("TRAINING")
                            .font(.custom("PaytoneOne-Regular", size: 36))
                            .foregroundColor(.white)
                            .padding(.top, 25)
                        
                        if (data.onAdventure == "") {
                            Text("Start training to strengthen an attribute! \n\n* Your character will come back at midnight the latest \n* 1 Lvl-Up / 500 Steps \n* One attribute per Training")
                                .font(.custom("PaytoneOne-Regular", size: 18))
                                .foregroundColor(.white)
                                .padding(.top, 1)
                            
                            Spacer()
                            
                            HStack (spacing: 30){
                                
                                // Button for training STA
                                if (trainingFocus == "STA") {
                                    Button { trainingFocus = "STA" } label: {
                                        Image("b_sta")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.accentColor, lineWidth: 5)
                                            )
                                    }
                                } else {
                                    Button {
                                        trainingFocus = "STA"
                                    } label: {
                                        Image("b_sta")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                    }
                                }
                                
                                // Button for training DEF
                                if (trainingFocus == "DEF") {
                                    Button { trainingFocus = "DEF" } label: {
                                        Image("b_def")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.accentColor, lineWidth: 5)
                                            )
                                    }
                                } else {
                                    Button {
                                        trainingFocus = "DEF"
                                    } label: {
                                        Image("b_def")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                    }
                                }
                                
                                // Button for training DEX
                                if (trainingFocus == "DEX") {
                                    Button { trainingFocus = "DEX" } label: {
                                        Image("b_dex")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.accentColor, lineWidth: 5)
                                            )
                                    }
                                } else {
                                    Button {
                                        trainingFocus = "DEX"
                                    } label: {
                                        Image("b_dex")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                    }
                                }
                            }
                            .padding(.bottom, 20)
                            
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
                        if (data.onAdventure == "" && trainingFocus != "") {     // Button for starting Training
                            Button {
                                startTraining()
                            } label: {
                                Image("b_start")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: metrics.size.width * 0.35)
                            }
                        } else if (data.onAdventure.contains("Training")) {             // Button for finishing Training
                            Button {
                                stopTraining()
                            } label: {
                                Image("b_stop")
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
