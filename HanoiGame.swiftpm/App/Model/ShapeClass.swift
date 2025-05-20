//
//  ShapeClass.swift
//  HanoiGame
//
//  Created by Harland Harrison on 3/17/25.
//

import Foundation
import SwiftUI


let coinCount0 = 4
let pinCount = 3


class ShapeClass : ObservableObject,Identifiable {
    var ObservableID:String
    var index = 0
    var label = ""
    var shapeType = 0
    var size = 0.0
    var color:Color = .gray
    
    @Published var offset = CGSize.zero
    @Published var startOffset = CGSize.zero
    @Published var canDrag = false
    @Published var isDragging = false
    
    init(shape:Int,size:Double) {
        ObservableID = NSUUID().uuidString
        self.shapeType = shape
        self.size = size
    }

    func coinColor(_ num:Int) -> Color {
        var c:Color = .red
        switch num%7 {
        case 1: c = .red
        case 2: c = .blue
        case 3: c = .green
        case 4: c = .yellow
        case 5: c = .cyan
        case 6: c = .orange
        default: c = .indigo
        }
        return c
    }
}

class TowersClass:ObservableObject {
    
    @Published var alert = ""
    @Published var vert = true

    var shapes:[ShapeClass] = [
        ShapeClass(shape:0,size:100)
    ]
    
    var autoSolve = false
    var coinCount = coinCount0
    
    init() {}
     
    func setAlert(_ s : String?) {
        // Update alert and guarantee a change
        // for refreshing the screen
        let CR = "\n"
        if let s = s {
            if s == "" {
                setAlert(CR+"\(coinCount) pieces")
            } else {
                alert = ""
                alert = s
                if !alert.hasSuffix(CR) {
                    setAlert(alert+CR)
                }
            }
        } else {
            setAlert(alert)
        }
    }

    
    func reset(coinCount:Int=coinCount0) {
        initData(coinCount)
        setDragPermissions()
        updateGameView(self,"")
    }
    
    func initData(_ count:Int) {
        shapes = []
        coinCount=count
        speed = 1.0
        var size = 160.0
        let step = size*1.25
        let p0 = -460.0+size/2
        for i in 0..<pinCount {
            addShape(shape:1,size:size,p0+Double(i)*step)
            let inx = shapes.count-1
            shapes[inx].label = ""
        }
        size = size * 0.95
        for i in 0..<coinCount {
            addShape(shape:0,size:size,p0)
            size = size * 0.85
            let inx = shapes.count-1
            let coin = shapes[inx]
            coin.color = coin.coinColor(coinCount-i)
            coin.label = "\(coinCount-i)"
        }
    }
    
    func addShape(shape:Int,size:Double,_ loc:Double = 0) {
        shapes.append(ShapeClass(shape:shape,size:size))
        let inx = shapes.count-1
        shapes[inx].index = inx
        shapes[inx].label = "\(inx)"
        shapes[inx].offset = CGSize(width: 0,height: loc)
        shapes[inx].startOffset = shapes[inx].offset
    }
    
    func findTopPiece(pin:Int) -> Int {
        setDragPermissions()
        let offset = shapes[pin].offset
        for i in 0..<shapes.count {
            let shape = shapes[i]
            if shape.offset == offset && shape.canDrag {
                return i
            }
        }
        return pin // no coins on pin
    }
    
    func setDragPermissions() {
        var pins:[String:Int] = [:]
        guard shapes.count > 0 else {return}
        var shape = shapes[0]
        for i in 0..<shapes.count {
            shape = shapes[i]
            if shape.shapeType == 0 {
                let key = "\(shape.offset)"
                let smallest = pins[key]
                if  smallest == nil {
                    pins[key] = i
                    shape.canDrag = true
                } else {
                    let small = shapes[smallest!]
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
    var speed = 1.0
    let minMsec = 2.0
    let maxMsec = 100.0
    func setOffset(shape:ShapeClass,newOffset:CGSize) {
        DispatchQueue.main.sync {
            withAnimation {
                shape.offset = newOffset
                setDragPermissions()
            }
        }
        let time = maxMsec * speed
        if time > minMsec {
            speed *= 0.995
        }
        Thread.sleep(forTimeInterval:time/1000.0)
    }
    
    func animateMove(_ from:Int,_ to:Int) {
        var fromShape:ShapeClass
        var toShape:ShapeClass
        var fromInx = 0
        var toInx = 0
        
        DispatchQueue.main.sync {
            fromInx = findTopPiece(pin:from)
            toInx = findTopPiece(pin:to)
        }
        fromShape = shapes[fromInx]
        toShape = shapes[toInx]
        
        var newOffset:CGSize;
        let step = 85.0 * Double(1-2*((from+to)%2))
        newOffset = fromShape.offset
        newOffset.width += step
        setOffset(shape:fromShape,newOffset:newOffset)
        newOffset.width += step
        setOffset(shape:fromShape,newOffset:newOffset)
        newOffset = toShape.offset
        newOffset.width += 2.0*step
        setOffset(shape:fromShape,newOffset:newOffset)
        newOffset.width -= step
        setOffset(shape:fromShape,newOffset:newOffset)
        newOffset = toShape.offset
        setOffset(shape:fromShape,newOffset:newOffset)
    }
    
    func move(count:Int,from:Int,to:Int) {
        guard autoSolve else {return} // allow reset
        // Use 0,1 and pinCount-1
        let spare = pinCount-from-to
        if count == 1 {
            animateMove(from,to)
        }
        if count < 2 {
            return
        }
        move(count:count-1, from:from, to:spare)
        move(count:1, from:from, to:to)
        move(count:count-1, from:spare, to:to)
    }
    
    
    func shapeHitTest(_ movedInx:Int) -> Int  {
        let moved = shapes[movedInx]
        for i in 0..<shapes.count {
            let test = shapes[i]
            // only test coins on pins
            if test.shapeType != moved.shapeType {
                let r1 = moved.size/2.0
                let r2 = test.size/2.0
                var c1:CGPoint = CGPoint.zero
                var c2:CGPoint = CGPoint.zero
                c1.x = moved.offset.width
                c1.y = moved.offset.height
                c2.x = test.offset.width
                c2.y = test.offset.height
                var found = false
                if hitTestCenterCircles(c1: c1, r1: r1, c2: c2, r2: r2) {
                    found = true
                }
                if found {
                    return i
                }
            }
        }
        return -1
    }
}

// Hit test two circles by radii & centers
func hitTestCenterCircles(c1:CGPoint,r1:Double,c2:CGPoint,r2:Double)-> Bool {
    let delX = c1.x - c2.x
    let delY = c1.y - c2.y
    let delR2 = delX*delX+delY*delY
    let minR2 = (r1+r2)*(r1+r2)
    return minR2 >= delR2
}
