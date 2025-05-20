//
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import SwiftUI

// Singleton for game board label
var gTitle:TitleClass = TitleClass()

class TitleClass: ObservableObject {
    @Published var title = ""
    init() {title = "Towers of Hanoi"}
}

@main
struct HanoiGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
