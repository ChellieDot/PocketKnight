import Foundation
import SwiftUI

struct AcceptFightView: View {
    
    @EnvironmentObject var data: DataManager
    
    @Binding var showAcceptView: Bool
    
    // declining the fight with the chosen opponent will send the user back to the MultiplayerView
    // or rather hide the AcceptFightView SubView
    func decline() {
        showAcceptView = false
    }
    
    // accepting the fight request will hide the AcceptFightView SubView and display the
    // FightView with the opponents characteristics (username and sprite)
    func accept() {
        showAcceptView = false
        data.showView = "Fight"
        
    }
    
    var body: some View {
        
        // Stack on Z-Axis to determine Background Image first
        // and every other element on top
        ZStack {
            
            VStack(spacing: 30) {
                Text("\(data.opponent.username) wants to fight!")
                    .font(.custom("PaytoneOne-Regular", size: 36))
                    .foregroundColor(.white)
                    .padding(.bottom, 40)
                
                HStack(spacing: 30) {
                    Button { decline() } label: {
                        Image("b_decline")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                    
                    Button { accept() } label: {
                        Image("b_accept")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                }
                .padding(.bottom, 30)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
            .background(
                Image("background_subview")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 5)
            )
            .padding(.top)
        }
    }
}
