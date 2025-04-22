//
//  ShapeClass.swift
//  HanoiGame
//
//  Created by Harland Harrison on 3/17/25.
//

import Foundation
import SwiftUI


class ShapeClass : ObservableObject,Identifiable {
    var ObservableID:String
    @Published var index = 0
    @Published var label = ""
    @Published var shapeType = 0
    @Published var size = 0.0
    @Published var color:Color = .gray
    @Published var url = "https://rickandmortyapi.com/api/character/avatar/824.jpeg"
   @Published var offset = CGSize.zero
   @Published var startOffset = CGSize.zero
   @Published var canDrag = false
   @Published var isDragging = false
    init(shape:Int,size:Double) {
        ObservableID = NSUUID().uuidString
        self.shapeType = shape
        self.size = size
        self.isDragging = false
    }
}

var gvShapes:[ShapeClass] = [
    ShapeClass(shape:0,size:100)
 ]


func pieceColor(_ num:Int) -> Color {
    var c:Color = .red
    switch num%7 {
    case 0: c = .yellow
    case 1: c = .green
    case 2: c = .red
    case 3: c = .teal
    case 4: c = .brown
    case 5: c = .cyan
    default: c = .red
    }
    return c
}

let coinCount0 = 4
let pinCount = 3
var coinCount = coinCount0

func reset() {
    gvShapes = []
    var size = 160.0
    let step = size*1.25
    let p0 = -500.0+size/2
    for i in 0..<pinCount {
        addShape(shape:1,size:size,p0+Double(i)*step)
        let inx = gvShapes.count-1
        gvShapes[inx].label = ""
    }
    for _ in 0..<coinCount {
        size = size * 0.85
        addShape(shape:0,size:size,p0)
        let inx = gvShapes.count-1
        gvShapes[inx].canDrag = false
        gvShapes[inx].color = pieceColor(inx)
        gvShapes[inx].label = "\(inx-2)"
     }
    gtitleObj.alert = ""
    setDragPermission()
}

func findTopPiece(pin:Int) -> Int {
    let offset = gvShapes[pin].offset
    for i in 0..<gvShapes.count {
        let shape = gvShapes[i]
        if shape.offset == offset && shape.canDrag {
            return i
        }
    }

    return pin
}

func move(count:Int,from:Int,to:Int) {
    if count == 0 {return}
    if count == 1 {
        let fromInx = findTopPiece(pin:from)
        let toInx = findTopPiece(pin:to)
        let fromShape = gvShapes[fromInx]
        let toShape = gvShapes[toInx]
        fromShape.offset.width = fromShape.offset.width + 100.0
        Thread.sleep(forTimeInterval:0.1)
        fromShape.offset = toShape.offset
        fromShape.offset.width = fromShape.offset.width + 100.0
        Thread.sleep(forTimeInterval:0.1)
        fromShape.offset = toShape.offset
        Thread.sleep(forTimeInterval:0.1)
        setDragPermission()
        print("move \(fromInx) \(toInx)")
        return
    }
    let spare = pinCount-from-to
    move(count:count-1, from:from, to:spare)
    move(count:1, from:from, to:to)
    move(count:count-1, from:spare, to:to)
}

func addShape(shape:Int,size:Double,_ loc:Double = 0) {
    gvShapes.append(ShapeClass(shape:shape,size:size))
    let inx = gvShapes.count-1
    gvShapes[inx].index = inx
    gvShapes[inx].label = "\(inx)"
    gvShapes[inx].offset = CGSize(width: 0,height: loc)
    gvShapes[inx].startOffset = gvShapes[inx].offset
}


func setDragPermission() {
    var pins:[String:Int] = [:]
    guard gvShapes.count > 0 else {return}
    var shape = gvShapes[0]
    for i in 0..<gvShapes.count {
        shape = gvShapes[i]
        if shape.shapeType == 0 {
            let key = "\(shape.offset)"
            let smallest = pins[key]
            if  smallest == nil {
                pins[key] = i
                shape.canDrag = true
            } else {
                var small = gvShapes[smallest!]
                if  small.size > shape.size {
                    small.canDrag = false
                    shape.canDrag = true
                    pins[key] = i
                } else {
                    small.canDrag = true
                    shape.canDrag = false
                }
            }
        }
    }
}


func shapeHitTest(_ movedInx:Int) -> Int  {
    var moved = gvShapes[movedInx]
    for i in 0..<gvShapes.count {
        let test = gvShapes[i]
        if i != movedInx {
            let w1 = moved.size
            let w2 = test.size
            let h1 = moved.size
            let h2 = test.size
            var c1:CGPoint = CGPoint.zero
            var c2:CGPoint = CGPoint.zero
            c1.x = moved.offset.width
            c1.y = moved.offset.height
            c2.x = test.offset.width
            c2.y = test.offset.height
            var found = false
            // Neither one is right.
            // The only hit test used is circle to square
            // if moved.shapeType == test.shapeType
            if hitTestCenterCircles(c1: c1, r1: moved.size/2, c2: c2, r2: test.size/2) {
                found = true
            }
            if hitTestCenterRects(c1:c1,w1:w1,h1:h1,c2:c2,w2:w2,h2:h2) {
                // found = true
            }
            if found {
                return i
            }
        }
    }
    return -1
}


// Hit test two rectangles by widths & centers
func hitTestCenterRects(c1:CGPoint,w1:Double,h1:Double,c2:CGPoint,w2:Double,h2:Double)-> Bool {
    if c1.x-0.5*w1 > c2.x+0.5*w2 {return false}
    if c2.x-0.5*w2 > c1.x+0.5*w1 {return false}
    if c1.y-0.5*h1 > c2.y+0.5*h2 {return false}
    if c2.y-0.5*h2 > c1.y+0.5*h1 {return false}
    return true
}

// Hit test two circles by radii & centers
func hitTestCenterCircles(c1:CGPoint,r1:Double,c2:CGPoint,r2:Double)-> Bool {
    let delX = c1.x - c2.x
    let delY = c1.y - c2.y
    let delR2 = delX*delX+delY*delY
    let minR2 = (r1+r2)*(r1+r2)
    return minR2 >= delR2
}
