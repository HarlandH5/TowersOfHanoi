//
//  Controller.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import Foundation

var auto = false

// Initialize game
func gInit(_ titles:TitleClass) -> Bool {
    // Set this screen
    gTitles = titles
    // Only init once
    guard gTowers.shapes.count < 4 else {return false}
    gTowers.initData(coinCount0)
    gTowers.setDragPermissions()
    gReset()
    return true
}

func gReset() {
    guard !auto else {return}
    gTowers.reset(coinCount:coinCount0)
    updateGameView("")
}

let q:DispatchQueue = DispatchQueue.global(qos: .userInteractive)

func gSolve() {
    guard !auto else {return}
    gTowers.reset(coinCount:coinCount)
    q.async {
        auto = true
        updateGameView("")
        gTowers.move(count:coinCount,from:0, to:pinCount-1)
        updateGameView("")
        auto = false
    }
}

func gAddCoin() {
    guard !auto else {return}
    gTowers.reset(coinCount:coinCount+1)
    updateGameView()
}

func gHitTest() {
    guard !auto else {return}
    var alert = ""
    var movedInx = -1
    var hitInx = -1
    
    for i in 0..<gTowers.shapes.count {
        if gTowers.shapes[i].isDragging {
            movedInx = i
            hitInx = gTowers.shapeHitTest(movedInx)
        }
    }
    if movedInx < 0 {return}
    
    let moved:ShapeClass = gTowers.shapes[movedInx]
    var hit:ShapeClass = gTowers.shapes[movedInx]
    var canMove = false
    if hitInx >= 0  { // Not touching ?
        hit = gTowers.shapes[hitInx]
        if hit.shapeType == 1 {canMove = true}
    }
    if canMove {
        // snap together
        moved.offset = hit.offset
        gTowers.setDragPermissions()
        canMove = moved.canDrag
        if !canMove {
            alert =
            "You cannot stack a larger coin \nwhere there is already a smaller coin."
        }
    }
    if !canMove {
        // move back
        moved.offset = moved.startOffset
    }
    updateGameView(alert)
}


func updateGameView(_ newAlert:String? = nil) {
  DispatchQueue.main.async {
        gTitles.title = ""
        var alert = gTitles.alert
        if let newAlert = newAlert {
          alert = newAlert
        }
        gTitles.setAlert("")
        gTitles.title = "Towers of Hanoi"
        gTitles.setAlert(alert)
        gTowers.setDragPermissions()
    }
}
