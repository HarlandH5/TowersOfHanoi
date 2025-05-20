//
//  SelectionRowView.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//


import SwiftUI

struct SelectionRowView: View {
    let title: String
    let description: String
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .frame(width: 30)
                .font(.title)
                .foregroundColor(.accentColor)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Text(description)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(10)
        }
    }
}

struct SelectionRowView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionRowView(title: "View Title", description: "Description of view's function", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
    }
}
