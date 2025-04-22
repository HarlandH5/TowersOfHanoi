/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct GameView: View {
    @ObservedObject var titleObj:TitleClass // = TitleClass()
    
    @AppStorage("HanoiTowersStorageLabel") var itemstor = "Hello World from Towers of Hnoi"
    
    var body: some View {
    
        GeometryReader { geo in // frame Size
            if gInit() {
                let vert = (geo.size.width < geo.size.height)
            }
        }
            VStack (spacing:25) {
                ZStack {
                    ForEach(gvShapes){
                        GameViewItem(shape: $0,vert:titleObj.vert)
                    }
                }
                Text("\(titleObj.alert)")
            }
            .navigationTitle("\(titleObj.title)")
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

struct CircleItem: View {
    @StateObject var shape:ShapeClass
   // private let itemSize: CGFloat = 100
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
   // private let itemSize: CGFloat = 100
   
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
            if shape.shapeType == 0 && shape.canDrag {
                CircleItem(shape: shape)
                .gesture(dragGesture)
                .gesture(longPressGesture)
            }
            if shape.shapeType == 0 && !shape.canDrag {
                CircleItem(shape: shape)
                .gesture(longPressGesture)
            }
            // Picture
            if shape.shapeType == 2 {
                Text(shape.label)
                /*
                ImageItemView(size:shape.size,url:shape.url)
                    .frame(width: shape.size, height: shape.size)
                    .offset(shape.offset)
                    .gesture(dragGesture)
                    .gesture(longPressGesture)
                 */
            }
            // Pin
            if shape.shapeType == 1 {
                ZStack {
                    Text(shape.label)
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
                .frame(width: shape.size, height: shape.size)
                .offset(shape.offset)
                .gesture(longPressGesture)
             }
        }
    }
}

