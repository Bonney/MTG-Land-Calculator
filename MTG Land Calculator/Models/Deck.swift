//
//  Deck.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/25/24.
//

import Foundation

struct Deck {
    var size: DeckSize
    var manaPips: [ManaColor: Int]
    var landRatio: Double

    func calculateLands() -> [ManaColor: Int] {
        let totalPips: Double = Double((manaPips.values.reduce(0, +)))
        guard totalPips > 0 else { return [:] }

        let totalLands: Double = (Double(size.cardCount) * landRatio)
        return manaPips.mapValues { Int((Double($0) / totalPips) * totalLands) }
    }
}
