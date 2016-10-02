//
//  TileView.swift
//  TreasureHuntGame
//
//  Created by 小林和宏 on 10/2/16.
//  Copyright © 2016 mycompany. All rights reserved.
//

import UIKit

class TileView: UIView {
  
  enum State {
    case notVisited
    case visitedByPlayer1
    case visitedByPlayer2
    case hasPrize
    case hasPlayer1
    case hasPlayer2
  }
  
  // Set a default state.
  var state: State = .notVisited {
    didSet {
      // Set a color for each status. Suppose there are two players.
      switch state {
      case .notVisited:
        self.backgroundColor = .lightGray
      case .visitedByPlayer1:
        self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
      case .visitedByPlayer2:
        self.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
      case .hasPrize:
        self.backgroundColor = .green
      case .hasPlayer1:
        self.backgroundColor = .red
      case .hasPlayer2:
        self.backgroundColor = .blue
      }
    }
  }
  
  
  override func draw(_ rect: CGRect) {
    clipsToBounds = true
    layer.cornerRadius = frame.size.width / 2.0
  }
}
