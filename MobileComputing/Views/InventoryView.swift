import Foundation
import SwiftUI

struct InventoryView: View {

    @EnvironmentObject var data: DataManager
    
    private var adventureManager = AdventureManager()
    private var potions: [Potion] = load("potions.json")        // only needed for display, no actual functionality implemented
    
    @State var potionTab = false
    
    func close() {
        data.showView = "Play"
    }
    
    func removeFromSlot(id: Int) {
        // since the item is already decreased for the inventory,
        // the sprite is simply updated to
        data.itemSlots[id].sprite = "b_blank"
        
        // determineRow is needed for the following database function
        // this function expects the id of an item, not the row it should
        // be displayed in.
        let determineRow = (id * 4)
        adventureManager.clearSlot(id: determineRow)
    }
    
    func getID(row: Int, col: Int) -> Int{
        var id = 0
        
        if (row == 0) {
            id = col
        } else if (row == 1){
            id = col + 4
        } else if (row == 2){
            id = col + 8
        }
        
        return id
    }
    
    func equipItem(id: Int) {
        
        let item = data.inventory[id]
        
        if (item.quantity > 0) {
            if (item.category == "Shield") {
                data.itemSlots[0].sprite = item.sprite
                data.itemSlots[0].turns = Int(item.durability)
            } else if (item.category == "Sword") {
                data.itemSlots[1].sprite = item.sprite
                data.itemSlots[1].turns = Int(item.durability)
            } else if (item.category == "Boots") {
                data.itemSlots[2].sprite = item.sprite
                data.itemSlots[2].turns = Int(item.durability)
            }
            
            adventureManager.useItem(id: id, sprite: data.inventory[id].sprite)
            data.inventory[id].quantity -= 1
            
        } else {
            print("0 from \(data.inventory[id].name)")
        }
    }
    
    var body: some View {
        
        // Stack on Z-Axis to determine Background Image first
        // and every other element on top
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_inventory")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
            
            // --------------------------------------------------------- CONTENT
            // Content is wrapped in GeometryReader to determine size by available space
            // (metrics.size.width * 0.xx) -> xx equals desired percentage of e.g. available width
            GeometryReader { metrics in
                
                HStack {
                    
                    // Left side
                    VStack {
                        HStack {
                            // Button for Gear-Tab
                            if (!potionTab) {
                                Button { potionTab = false } label: {
                                    Image("t_gear_on")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                }
                            } else {
                                Button {
                                    potionTab = false
                                } label: {
                                    Image("t_gear_off")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                }
                            }
                            
                            // Button for Potion-Tab
                            if (potionTab) {
                                Button { potionTab = true } label: {
                                    Image("t_potion_on")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                }
                            } else {
                                Button {
                                    potionTab = true
                                } label: {
                                    Image("t_potion_off")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.50), minHeight: 0, maxHeight: (metrics.size.height * 0.10), alignment: .leading)
                        .padding(.leading, 40)
                        
                        VStack {
                            if (!potionTab) {
                                
                                VStack {
                                    ForEach(0..<3, id: \.self) { row in
                                        HStack {
                                            ForEach(0..<4, id: \.self) { col in
                                                let id = getID(row: row, col: col)
                                                
                                                Button { equipItem(id: id) } label: {
                                                    ZStack {
                                                        Image(data.inventory[id].sprite)
                                                            .resizable()
                                                        Text("\(Int(data.inventory[id].quantity))")
                                                            .foregroundColor(Color.white)
                                                            .font(.custom("PaytoneOne-Regular", size: 20))
                                                            .shadow(color: .black, radius: 5, x: 2, y: 5)
                                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomTrailing)
                                                            .padding(.bottom, 5)
                                                            .padding(.trailing, 10)
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: metrics.size.width * 0.40)
                                    }
                                }
                                .frame(height: metrics.size.height * 0.60)
                                .padding(.top, 10)
                                
                            } else {
                                
                                VStack {
                                    ForEach(0..<2, id: \.self) { row in
                                        HStack {
                                            ForEach(0..<4, id: \.self) { col in
                                                let id = getID(row: row, col: col)
                                                
                                                Button { print("IN WORK!") } label: {
                                                    ZStack {
                                                        Image(potions[id].sprite)
                                                            .resizable()
                                                        Text("\(Int(potions[id].quantity))")
                                                            .foregroundColor(Color.white)
                                                            .font(.custom("PaytoneOne-Regular", size: 20))
                                                            .shadow(color: .black, radius: 5, x: 2, y: 5)
                                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomTrailing)
                                                            .padding(.bottom, 5)
                                                            .padding(.trailing, 10)
                                                    }
                                                }
                                            }
                                            
                                        }
                                        .frame(width: metrics.size.width * 0.40)
                                    }
                                    HStack {
                                        ForEach(0..<4, id: \.self) { col in
                                            // an invisible line to ensure the right height of the stacks
                                            Color.clear
                                        }
                                    }
                                    .frame(width: metrics.size.width * 0.40)
                                }
                                .frame(height: metrics.size.height * 0.60)
                                .padding(.top, 10)
                                
                            }
                        }
                        .padding(.top, 20)
                    }
                    .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.50), minHeight: 0, maxHeight: metrics.size.height)
                    .background(
                        Image("Inv_BG")
                            .resizable()
                    )
                    
                    // Right Side
                    Image(data.sprite)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: (metrics.size.width * 0.50))
                        .padding(.top, 20)
                        .padding(.trailing, 100)
                    
                }
                .padding(.top)
            }
            
            // --------------------------------------------------------- CLOSE BUTTON + ITEM SLOTS
            VStack (alignment: .trailing) {
                Button { close() } label: {
                    Image("b_close")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                }
                
                Spacer()
                
                VStack {
                    ForEach(data.itemSlots) { item in
                        Button { removeFromSlot(id: item.id) } label: {
                            Image(item.sprite)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70)
                        }
                    }
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topTrailing)
            .padding(.top)
            
        }
    }
}
