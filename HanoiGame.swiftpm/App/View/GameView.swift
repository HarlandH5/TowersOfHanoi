//
//  GameView.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import SwiftUI


struct GameView: View {
    @ObservedObject var titles:TitleClass
    @ObservedObject var towers:TowersClass
    
    @AppStorage("HanoiTowersStorageLabel")
    var itemstor = "Hello World from Towers of Hanoi"
    
    var y : Bool = false
    var body: some View {
        GeometryReader { geo in // frame Size
            if gInit(titles,towers) {
                 let _ = (geo.size.width < geo.size.height)
             }
        }
            VStack (spacing:25) {
                ZStack {
                    // Draw shapes in order except for
                    // coin being dragged is always last
                    ForEach(towers.shapes){
                        GameViewItem(towers:towers,shape:$0,vert:towers.vert)
                     }
                }
                Text("\(towers.alert)")
             }
            
            .navigationTitle("\(titles.title)")
            .toolbar {
                ToolbarItem {
                    Button("Solve") {
                        gSolve(towers)
                        
                    }.disabled(towers.autoSolve)
                }
                ToolbarItem {
                    Button("Add Coin") {
                        gAddCoin(towers)
                    }.disabled(towers.autoSolve)
                }
                ToolbarItem {
                    Button("Reset") {
                        gReset(towers)
                    }
                }
           }
    }
        
}




struct SquareItem: View {
        @StateObject var shape:ShapeClass
        var body: some View {
            
            VStack {
                ZStack {
                    Text(shape.label)
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
                .frame(width: shape.size, height: shape.size)
                .offset(shape.offset)
            }
        }
    }

    
struct CircleItem: View {
        @StateObject var shape:ShapeClass
        var body: some View {
            
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(shape.color)
                        .opacity(1.0)
                    Text(shape.label)
               }
                        .frame(width: shape.size, height: shape.size)
                        .offset(shape.offset)
            }
        }
    }

    
struct GameViewItem: View {
    @StateObject var towers:TowersClass
    @StateObject var shape:ShapeClass
    @State var vert:Bool
   
    var dragGesture: some Gesture {
       // DragGesture(coordinateSpace: .named("global"))
        DragGesture()
            .onEnded { value in
                withAnimation {
                    gHitTest(towers)
                    shape.isDragging = false
                }
           }
            .onChanged { value in
                if !shape.isDragging {
                    shape.isDragging = true
                    shape.startOffset = shape.offset
                }
                shape.offset = CGSize(
                    width: value.translation.width+shape.startOffset.width,
                    height: value.translation.height+shape.startOffset.height)
            }
    }

    var body: some View {
        VStack {
            // Disk
            if shape.shapeType == 0 {
                if towers.autoSolve{
                    CircleItem(shape: shape)
                } else {
                    if shape.canDrag {
                        CircleItem(shape: shape)
                        .gesture(dragGesture)

                    } else {
                        CircleItem(shape: shape)
                    }
                }
            }
            // Pin
            if shape.shapeType == 1 {
                SquareItem(shape: shape)
            }
        }
    }
}

