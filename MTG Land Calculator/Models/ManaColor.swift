//
//  ManaColor.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/25/24.
//

import SwiftUI
import Foundation

enum ManaColor: String, CaseIterable {
  case white, blue, black, red, green

  @ViewBuilder
  var symbolImage: some View {
    let color: Color = switch self {
      case .white:    Color.white
      case .blue:     Color.blue
      case .black:    Color.black
      case .red:      Color.red
      case .green:    Color.green
    }

    Circle()
      .fill(color)
      .stroke(Color.gray, lineWidth: 1.0)
      .frame(width: 24.0, height: 24.0)
  }

  var symbol: String {
    switch self {
      case .white:    "{W}"
      case .blue:     "{U}"
      case .black:    "{B}"
      case .red:      "{R}"
      case .green:    "{G}"
    }
  }

  var landName: String {
    switch self {
      case .white:    "Plains"
      case .blue:     "Islands"
      case .black:    "Swamps"
      case .red:      "Mountains"
      case .green:    "Forests"
    }
  }
}
