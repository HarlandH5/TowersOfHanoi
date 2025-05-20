//
//  ContentView.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: AboutView(titles:gTitle)) {
                    SelectionRowView(title: "About", description: "Find out about Towers of Hanoi.", systemImage: "hand.point.up.left")
                }

                NavigationLink(destination: RulesView(titles:gTitle)) {
                    SelectionRowView(title: "Rules", description: "How to play Towers of Hanoi", systemImage: "book.closed.fill")
                }
                
                NavigationLink(destination:  GameView(titles:gTitle,towers:TowersClass()))
                 {
                    SelectionRowView(title: "Play", description: "Towers of Hanoi.", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
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
