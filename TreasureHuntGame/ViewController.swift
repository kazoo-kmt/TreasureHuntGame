//
//  ViewController.swift
//  TreasureHuntGame
//
//  Created by 小林和宏 on 10/2/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var gridView: GridView!
  var player1: Player!
  var player2: Player!
  
  var timer: Timer!
  
  enum PlayerTurn {
    case playerOne
    case playerTwo
  }
  var playerTurn: PlayerTurn = .playerOne
  
  let leftMargin: CGFloat = 20
  let topMargin: CGFloat = 100
  lazy var rectFrame: CGRect = CGRect(x: UIScreen.main.bounds.origin.x + self.leftMargin, y: UIScreen.main.bounds.origin.y + self.topMargin, width: UIScreen.main.bounds.size.width - self.leftMargin * 2, height: UIScreen.main.bounds.size.width - self.leftMargin * 2)
  
  @IBOutlet weak var scorePlayer1Label: UILabel!
  @IBOutlet weak var scorePlayer2Label: UILabel!
  
  @IBAction func startButtonTapped(_ sender: AnyObject) {
    
    startSimulation()
  }
  
  @IBAction func resetPositionButtonTapped(_ sender: AnyObject) {
    
    timer.invalidate()
    
    clear()
    
    player1 = setInitialPosForPlayer(initialRowIndex: gridView.numOfTilesPerRow - 1, initialColumnIndex: 0, player: player1)
    player2 = setInitialPosForPlayer(initialRowIndex: 0, initialColumnIndex: gridView.numOfTilesPerColumn - 1, player: player2)
    setInitialPosForPrize()
  }
  
  @IBAction func resetScoreButtonTapped(_ sender: AnyObject) {
    timer.invalidate()
    
    player1.score = 0
    player2.score = 0
    
    updateScoreLabel()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    gridView = GridView(frame: rectFrame)
    
    view.addSubview(gridView)
    
    // Initialize players and give dummy index
    player1 = Player(playerId: PlayerId.playerOne, rowIndex: 0, columnIndex: 0, score: 0, reachedPrize: false)
    player2 = Player(playerId: PlayerId.playerTwo, rowIndex: 0, columnIndex: 0, score: 0, reachedPrize: false)
    
    // Initial players' positions are given by tbe instruction paper and prize's position is randomly assigned.
    player1 = setInitialPosForPlayer(initialRowIndex: gridView.numOfTilesPerRow - 1, initialColumnIndex: 0, player: player1)
    player2 = setInitialPosForPlayer(initialRowIndex: 0, initialColumnIndex: gridView.numOfTilesPerColumn - 1, player: player2)
    setInitialPosForPrize()
    
    updateScoreLabel()
  }
  
  
  func setInitialPosForPlayer(initialRowIndex: Int, initialColumnIndex: Int, player: Player) -> Player {
    
    var newPlayer = player
    
    var hasPlayerState: TileView.State
    switch player.playerId {
    case .playerOne:
      hasPlayerState = .hasPlayer1
    case .playerTwo:
      hasPlayerState = .hasPlayer2
    }
    
    gridView.tileStates[initialRowIndex][initialColumnIndex].state = hasPlayerState
    
    // Update the player's position
    newPlayer.rowIndex = initialRowIndex
    newPlayer.columnIndex = initialColumnIndex
    newPlayer.reachedPrize = false
    
    return newPlayer
  }
  
  
  func setInitialPosForPrize() {
    let rowIndexForPrize = Int(arc4random_uniform(UInt32(gridView.numOfTilesPerRow)))
    let columnIndexForPrize: Int
    
    if (rowIndexForPrize == 0 || rowIndexForPrize == gridView.numOfTilesPerRow - 1) {
      columnIndexForPrize = Int(arc4random_uniform(UInt32(gridView.numOfTilesPerColumn - 2)) + 1)
    } else {
      columnIndexForPrize = Int(arc4random_uniform(UInt32(gridView.numOfTilesPerColumn)))
    }
    gridView.tileStates[rowIndexForPrize][columnIndexForPrize].state = TileView.State.hasPrize
  }
  
  
  func startSimulation() {
    if (player1.reachedPrize == false && player2.reachedPrize == false) {
      timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchAndMove), userInfo: nil, repeats: true)
    }
  }
  
  
  func searchAndMove() {
    
    // Player1's turn
    if playerTurn == .playerOne {
      
      let newPos: (Int, Int) = search(player: player1)
      player1 = move(newRowIndex: newPos.0, newColumnIndex: newPos.1, player: player1)
      
      playerTurn = .playerTwo
      
      // Player2's turn
    } else {
      
      let newPos: (Int, Int) = search(player: player2)
      player2 = move(newRowIndex: newPos.0, newColumnIndex: newPos.1, player: player2)
      
      playerTurn = .playerOne
    }
    
    if player1.reachedPrize == true || player2.reachedPrize == true {
      updateScoreLabel()
      timer.invalidate()
    }
  }
  
  
  func search(player: Player) -> (Int, Int){
    
    var visitedByPlayerState: TileView.State
    switch player.playerId {
    case .playerOne:
      visitedByPlayerState = .visitedByPlayer1
    case .playerTwo:
      visitedByPlayerState = .visitedByPlayer2
    }
    
    // Check whether it can move or not ()
    let currentRowIndex = player.rowIndex
    let currentColumnIndex = player.columnIndex
    
    let delta = [[-1, 0 ], // go up
      [ 0, -1], // go left
      [ 1, 0 ], // go down
      [ 0, 1 ]] // go right
    
    var canMove = false
    
    while canMove != true {
      
      let randomDirection = Int(arc4random_uniform(4))
      let newRowIndex    = currentRowIndex + delta[randomDirection][0]
      let newColumnIndex = currentColumnIndex + delta[randomDirection][1]
      
      if newRowIndex < 0 || newRowIndex > gridView.numOfTilesPerRow - 1 || newColumnIndex < 0 || newColumnIndex > gridView.numOfTilesPerColumn - 1 {
        continue
      }
      
      if gridView.tileStates[newRowIndex][newColumnIndex].state == .notVisited ||
        gridView.tileStates[newRowIndex][newColumnIndex].state == visitedByPlayerState ||
        gridView.tileStates[newRowIndex][newColumnIndex].state == .hasPrize {
        
        canMove = true
        return (newRowIndex, newColumnIndex)
      }
    }
    return (-1, -1)
  }
  
  
  func move(newRowIndex: Int, newColumnIndex: Int, player: Player) -> Player{
    return gridView.move(newRowIndex: newRowIndex, newColumnIndex: newColumnIndex, player: player)
  }
  
  func clear() {
    gridView.clear()
  }
  
  func updateScoreLabel() {
    scorePlayer1Label.text = String(player1.score)
    scorePlayer2Label.text = String(player2.score)
  }
}

