/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GameView: View {
    @ObservedObject var titles:TitleClass
    
    @AppStorage("HanoiTowersStorageLabel")
    var itemstor = "Hello World from Towers of Hanoi"
    
    var body: some View {    
        GeometryReader { geo in // frame Size
             if gInit(titles) {
                 let _ = (geo.size.width < geo.size.height)
             }
        }
            VStack (spacing:25) {
                ZStack {
                    // Draw shapes in order except for
                    // coin being dragge is always last
                    ForEach(gTowers.shapes){
                            GameViewItem(shape: $0,vert:titles.vert)
                     }
                }
                Text("\(titles.alert)")
             }
            
            .navigationTitle("\(titles.title)")
            .toolbar {
                ToolbarItem {
                    Button("Solve") {
                        gSolve()
                        
                    }
                }
                ToolbarItem {
                    Button("Add Coin") {
                        gAddCoin()
                    }
                }
                ToolbarItem {
                    Button("Reset") {
                        gReset()
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
    @StateObject var shape:ShapeClass
    @State var vert:Bool
   
    var dragGesture: some Gesture {
       // DragGesture(coordinateSpace: .named("global"))
        DragGesture()
            .onEnded { value in
                gHitTest()
                shape.isDragging = false
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
    var longPressGesture: some Gesture {
        LongPressGesture()
            .onEnded { value in
                print("LongPressGesture \(value)")
            }
    }

    var body: some View {
        VStack {
            // Disk
            if shape.shapeType == 0 {
                if auto{
                    CircleItem(shape: shape)
                } else {
                    if shape.canDrag {
                        CircleItem(shape: shape)
                        .gesture(dragGesture)
                        .gesture(longPressGesture)

                    } else {
                        CircleItem(shape: shape)
                        .gesture(longPressGesture)

                    }
                }
            }
            // Pin
            if shape.shapeType == 1 {
                SquareItem(shape: shape)
                .gesture(longPressGesture)
             }
        }
    }
}

