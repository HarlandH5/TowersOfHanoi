/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: AboutView()) {
                    GestureRow(title: "About", description: "Find out about Towers of Hanoi.", systemImage: "hand.point.up.left")
                }

                NavigationLink(destination: RulesView()) {
                    GestureRow(title: "Rules", description: "How to play Towers of Hanoi", systemImage: "book.closed.fill")
                }
                
                NavigationLink(destination:  GameView(titles:gTitles))
                 {
                    GestureRow(title: "Play", description: "Towers of Hanoi.", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                }
            }
            .navigationTitle("Towers of Hanoi")
        } detail: {
            Text("Make a Selection")
                .foregroundColor(.secondary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
