//
//  Controller.swift
//  HanoiGame
//
//  Created by Harland Harrison on 4/16/25.
//

import Foundation

// Initialize game
func gInit(_ titles:TitleClass, _ towers:TowersClass) -> Bool {
    // Select this screen
    gTitle = titles
    // Only init once
    guard towers.shapes.count < 4 else {
        return false}
    gReset(towers)
    return true
}

func gReset(_ towers:TowersClass) {
    guard !towers.autoSolve else {
        towers.autoSolve = false
        return}
    towers.reset(coinCount:coinCount0)
}

func gAddCoin(_ towers:TowersClass) {
    guard !towers.autoSolve else {return}
    towers.reset(coinCount:towers.coinCount+1)
}

func gHitTest(_ towers:TowersClass) {
    guard !towers.autoSolve else {return}
    var alert = ""
    var movedInx = -1
    var hitInx = -1
    
    for i in 0..<towers.shapes.count {
        if towers.shapes[i].isDragging {
            movedInx = i
            hitInx = towers.shapeHitTest(movedInx)
        }
    }
    if movedInx < 0 {return}
    
    let moved:ShapeClass = towers.shapes[movedInx]
    var hit:ShapeClass = towers.shapes[movedInx]
    var canMove = false
    if hitInx >= 0  { // Not touching ?
        hit = towers.shapes[hitInx]
        if hit.shapeType == 1 {canMove = true}
    }
    if !canMove {
        alert =
        "You can only stack coins \non the three square pins."
    }
    if canMove {
        // snap together
        moved.offset = hit.offset
        towers.setDragPermissions()
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
    updateGameView(towers,alert)
}

let q:DispatchQueue = DispatchQueue.global(qos: .userInteractive)

func gSolve(_ towers:TowersClass) {
    guard !towers.autoSolve else {return}
    towers.reset(coinCount:towers.coinCount)
    q.async {
        towers.autoSolve = true
        updateGameView(towers,"")
        towers.move(count:towers.coinCount,from:0, to:pinCount-1)
        updateGameView(towers,"")
        towers.autoSolve = false
    }
}

func updateGameView(_ towers:TowersClass, _ newAlert:String? = nil) {
  DispatchQueue.main.async {
      towers.setDragPermissions()
      towers.setAlert(newAlert)
   }
}
