import Foundation
import SwiftUI

struct CreatePlayerView: View {
    
    @EnvironmentObject private var data: DataManager
    
    private var adventureManager = AdventureManager()
    private var database = DBStore.shared
    private var startup = StartupManager()
    
    @State private var username: String = ""
    @State private var playerClass: String = ""
    @State private var sprite = ""
    @State private var classInfo = ""
    
    func title() {
        data.showView = "Title"
    }
    
    // create calls the createUser function of the AdventureManager and subsequently
    // sets the runtime data from DataManager back to its initial value
    func create() {
        adventureManager.createUser(username: username, playerClass: playerClass)
        data.username = username                        // set runtime Data in "data"
        data.sprite = sprite
        data.inventory = startup.loadInventory()
        data.itemSlots = database.checkItemSlots()
        let attributes = startup.getAttributes()        // set initial Attribute values from DB
        if attributes != [] {
            data.sta = attributes[0]
            data.def = attributes[1]
            data.dex = attributes[2]
        }
        data.showView = "Title"                         // lastly, change view back to TitleScreenView
    }
    
    var body: some View {
        
        ZStack {
            
            // --------------------------------------------------------- BACKGROUND
            Color.clear
                .background(
                    Image("background_charcrea")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )
            
            // --------------------------------------------------------- CONTENT
            VStack {
                
                Text("CHARACTER CREATION")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                HStack {
                    
                    // Left Side of Screen
                    VStack {
                        // Text Field for Character Name
                        TextField("Character Name:", text: $username)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .font(.system(size: 25, weight: Font.Weight.bold))
                            .foregroundColor(Color.black)
                            .frame(width: 460, height: 50)
                            .background(
                                Color.white
                                    .opacity(0.8)
                                    .padding([.top, .bottom], -5)
                                    .padding([.leading, .trailing], -15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 5)
                                    .padding([.top, .bottom], -5)
                                    .padding([.leading, .trailing], -15))
                            .padding(.all, 20)
                        
                        // Buttons with Class-Choices
                        HStack {
                            
                            // Button for Paladin
                            if (playerClass == "PLD") {
                                Button { playerClass = "PLD" } label: {
                                    Image("b_paladin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.accentColor, lineWidth: 5)
                                        )
                                }
                            } else {
                                Button {
                                    playerClass = "PLD"
                                    sprite = "sprites_PLD"
                                    classInfo = "+ DEF, - STA"
                                } label: {
                                    Image("b_paladin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                }
                            }
                            
                            // Button for Thief
                            if (playerClass == "ROG") {
                                Button { playerClass = "ROG" } label: {
                                    Image("b_thief")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.accentColor, lineWidth: 5)
                                        )
                                }
                            } else {
                                Button {
                                    playerClass = "ROG"
                                    sprite = "sprites_ROG"
                                    classInfo = "+ DEX, - DEF"
                                } label: {
                                    Image("b_thief")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                }
                            }
                            
                            // Button for Mage
                            if (playerClass == "SMG") {
                                Button { playerClass = "SMG" } label: {
                                    Image("b_mage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 5)
                                                .stroke(Color.accentColor, lineWidth: 5)
                                        )
                                }
                            } else {
                                Button {
                                    playerClass = "SMG"
                                    sprite = "sprites_SMG"
                                    classInfo = "+ STA, - DEX"
                                } label: {
                                    Image("b_mage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                }
                            }
                        }
                        
                        Text(classInfo)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Back and Accept Buttons (Reset values upon click)
                        HStack {
                            Button {
                                username = ""
                                playerClass = ""
                                sprite = ""
                                classInfo = ""
                                title()
                            } label: {
                                Image("b_back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160)
                            }
                            
                            // only show create button if username and class are given
                            if (username != "" && playerClass != "") {
                                Button {
                                    create()
                                    username = ""
                                    playerClass = ""
                                    sprite = ""
                                    classInfo = ""
                                } label: {
                                    Image("b_create")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160)
                                }
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Right Side with chosen Class-Sprite
                    Image(sprite)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                }
            }
            .padding()
        }
    }
}
