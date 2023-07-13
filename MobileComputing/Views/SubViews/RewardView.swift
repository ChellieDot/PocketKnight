import Foundation
import SwiftUI

struct RewardView: View {
    
    @Binding var showReward: Bool
    @Binding var rewards: [String]
    
    func close() {
        showReward = false
    }
    
    var body: some View {
        
        // Stack on Z-Axis to determine Background Image first
        // and every other element on top
        ZStack {
            
            VStack(spacing: 30) {
                VStack {
                    ForEach(rewards, id: \.self) { reward in
                        Text(reward)
                            .font(.custom("PaytoneOne-Regular", size: 32))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
                
                Button { close() } label: {
                    Image("b_collect")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
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
