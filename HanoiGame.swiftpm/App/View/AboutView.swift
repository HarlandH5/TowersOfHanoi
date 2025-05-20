//
//  AboutView.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import SwiftUI

struct AboutView: View {
    @ObservedObject var titles:TitleClass
    var body: some View {
        VStack {
            Text(titles.title)
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
        AboutView(titles:gTitle)
    }
}
