//
//  Player.swift
//  TreasureHuntGame
//
//  Created by 小林和宏 on 10/2/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import Foundation

enum PlayerId {
  case playerOne
  case playerTwo
}


struct Player {
  let playerId: PlayerId
  var rowIndex: Int
  var columnIndex: Int
  var score: Int
  var reachedPrize: Bool
}
