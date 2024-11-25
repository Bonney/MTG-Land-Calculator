//
//  DeckSize.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/25/24.
//

import Foundation

enum DeckSize: String, CaseIterable {
  case sealed = "Sealed"
  case constructed = "Constructed"
  case commander = "Commander"
  
  var cardCount: Int {
    switch self {
      case .sealed:      40
      case .constructed: 60
      case .commander:   100
    }
  }
}
