// SCENE:   A scene represents a part of the apps UI that has a lifecycle.
//          Each scene acts as a root element for its View hierarchy
//          see: https://developer.apple.com/documentation/swiftui/scenes
//
// VIEW:    Views are building blocks that declare the apps UI.
//          Each view contains a description of what to display for a given state.
//          Views can contain other views and be modified, given they conform to the View protocol.
//          see: https://developer.apple.com/documentation/swiftui/view-fundamentals

import SwiftUI

// Main Method that gets called upon startup
// TODO: this should trigger the LaunchScreenAnimation and end up showing ContentView()
@main
struct MobileComputingApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
