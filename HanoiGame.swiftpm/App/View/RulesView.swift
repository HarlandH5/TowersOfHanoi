
/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct RulesView: View {
    
    var body: some View {
        VStack {
            Text("How to play Towers of Hanoi")
            Text("")
            Text("The object is to move the stack of round coins to the bottom square.")
            Text("")
            Text("You can only move the top coin on any stack.")
            Text("")
            Text("You cannot put a large coin on a smaller coin.")
            Text("")
            Text("You can only place the coins in stacks on the squares.")
            Text("")
            Text("")
            Text("Tap 'Add Coin' to make the game harder.")
            Text("")
            Text("Tap 'Reset' to start over.")
            Text("")
            Text("Tap 'Solve' to see how it is done.")

            Spacer()
        }
        .navigationTitle("Rules")
        .padding()
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
