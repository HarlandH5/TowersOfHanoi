//
//  Controller.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import Foundation

// Initialize game
func gInit() -> Bool {
    // Only init once
    guard gvShapes.count < 4 else {return false}
    coinCount = coinCount0
    reset()    
    return true
}

func gReset() {
    coinCount = coinCount0
    reset()
    gUpdateGameView()
}

func gSolve() {
    reset()
    gUpdateGameView()

    // DispatchQueue.main
    let q:DispatchQueue = DispatchQueue.global(qos: .userInteractive)
    
    q.async {
        move(count:coinCount,from:0, to:pinCount-1)
    }

}

func gAddCoin() {
    coinCount = coinCount + 1
    reset()
    gUpdateGameView()
}

func gUpdateGameView() {
    gtitleObj.title = ""
    setDragPermission()
    if gtitleObj.alert == "" {
        gtitleObj.alert = "\(coinCount) pieces\n "
    }
    gtitleObj.title = "Towers of Hanoi"
}


func gHitTest() {
    var movedInx = -1
    var hitInx = -1
    
    for i in 0..<gvShapes.count {
        let test = gvShapes[i]
        if test.isDragging {
            movedInx = i
            hitInx = shapeHitTest(movedInx)
        }
    }
    var moved:ShapeClass = gvShapes[movedInx]
    var hit:ShapeClass = gvShapes[movedInx]
    var canMove = false
    gtitleObj.alert = ""
    if movedInx < 0 {return}
    if hitInx >= 0  { // Not touching ?
        moved = gvShapes[movedInx]
        hit = gvShapes[hitInx]
        if hit.shapeType == 1 {canMove = true}
        // if hit.size < moved.size {canMove = false}
    }
    if canMove {
        // snap together
        moved.offset = hit.offset
        setDragPermission()
        canMove = moved.canDrag
        if !canMove {
            gtitleObj.alert =
            "You cannot put a larger piece\n on top of a smaller piece."
        }
    }
    if !canMove {
        // move back
        moved.offset = moved.startOffset
    }
    gUpdateGameView()
}

