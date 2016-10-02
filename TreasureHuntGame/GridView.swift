//
//  GridView.swift
//  TreasureHuntGame
//
//  Created by 小林和宏 on 10/2/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit

class GridView: UIView {
  
  let numOfTilesPerRow: Int
  let numOfTilesPerColumn: Int
  
  var tileStates = [[TileView]]()
  
  // The number of tiles per row/column is hardcoded here.
  init(frame: CGRect, numOfTilesPerRow: Int = 5, numOfTilesPerColumn: Int = 5) {
    
    self.numOfTilesPerRow = numOfTilesPerRow
    self.numOfTilesPerColumn = numOfTilesPerColumn
    
    super.init(frame: frame)
    
    let tileLength = frame.size.width / CGFloat(numOfTilesPerColumn)
    
    for i in 0..<numOfTilesPerRow {
      
      tileStates += [[]]
      
      for j in 0..<numOfTilesPerColumn {
        
        let xPosition = j % numOfTilesPerColumn
        let x = CGFloat(xPosition) * tileLength
        
        let yPosition = i % numOfTilesPerRow
        let y = CGFloat(yPosition) * tileLength
        
        let frame = CGRect(x: x, y: y, width: tileLength, height: tileLength)
        let tileView = TileView(frame: frame)
        
        // Set the default color.
        tileView.backgroundColor = .lightGray
        
        // Keep track each tile's state.
        tileStates[i] += [tileView]
        addSubview(tileView)
      }
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func move(newRowIndex: Int, newColumnIndex: Int, player: Player) -> Player {
    
    var newPlayer = player
    
    let currentRowIndex = player.rowIndex
    let currentColumnIndex = player.columnIndex
    let originalStateOfNext = tileStates[newRowIndex][newColumnIndex].state
    
    var hasPlayerState: TileView.State
    var visitedByPlayerState: TileView.State
    
    switch player.playerId {
    case .playerOne:
      hasPlayerState = .hasPlayer1
      visitedByPlayerState = .visitedByPlayer1
    case .playerTwo:
      hasPlayerState = .hasPlayer2
      visitedByPlayerState = .visitedByPlayer2
    }
    
    // Change the state from notVisited/visitedByPlayer/hasPrize to hasPlayerX
    tileStates[newRowIndex][newColumnIndex].state = hasPlayerState
    
    // Change the state from hasPlayer to notVisited/visitedByPlayer.
    // Once reached to the prize, finish the process and count the number.
    switch originalStateOfNext {
    case .hasPrize:
      tileStates[currentRowIndex][currentColumnIndex].state = visitedByPlayerState
      newPlayer.reachedPrize = true
      newPlayer.score += 1
      
    case visitedByPlayerState:
      tileStates[currentRowIndex][currentColumnIndex].state = .notVisited
    case .notVisited:
      tileStates[currentRowIndex][currentColumnIndex].state = visitedByPlayerState
    default:
      break
    }
    
    // Update the player's position
    newPlayer.rowIndex = newRowIndex
    newPlayer.columnIndex = newColumnIndex
    
    return newPlayer
  }
  
  
  func clear() {
    for i in 0..<numOfTilesPerRow {
      for j in 0..<numOfTilesPerColumn {
        tileStates[i][j].state = .notVisited
      }
    }
  }
  
  
}
