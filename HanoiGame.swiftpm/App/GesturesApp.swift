/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

// Singleton for game board
var gTowers:TowersClass = TowersClass()
var gTitles:TitleClass = TitleClass()

class TitleClass: ObservableObject {
    @Published var title =
    "Towers of Hanoi"
    @Published var alert = ""
    @Published var vert = true
    init() {}
    func setAlert(_ s : String) {
        alert = s
        if s == "" {
            alert = "\(coinCount) pieces\n "
        } else {
            alert = s
        }
    }
}

@main
struct TowerGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
