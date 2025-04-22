/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct AboutView: View {
    
    var body: some View {
        VStack {
            Text("Towers of Hanoi")
            Text("Written by Harland Harrison")
            Text("HarlandH5@yahoo.fr")
 
            Spacer()
        }
        .navigationTitle("About")
        .padding()
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
