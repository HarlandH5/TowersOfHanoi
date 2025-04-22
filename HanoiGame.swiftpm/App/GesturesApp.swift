/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI


var gtitleObj:TitleClass = TitleClass()

class TitleClass: ObservableObject {
    @Published var title =
    "Towers of Hanoi"
    @Published var alert = ""
    @Published var vert = true
}

@main
struct GesturesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
