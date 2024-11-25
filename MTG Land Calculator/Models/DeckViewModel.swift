//
//  DeckViewModel.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/25/24.
//

import Observation

@Observable
class DeckViewModel {
    var selectedDeckSize: DeckSize = .sealed

    var manaPips: [ManaColor: Int] = {
        var initialPips = [ManaColor: Int]()
        ManaColor.allCases.forEach { initialPips[$0] = 0 }
        return initialPips
    }()

    var landRatio: Double = 0.4

    var calculatedLands: [ManaColor: Int] {
        let deck = Deck(size: selectedDeckSize, manaPips: manaPips, landRatio: landRatio)
        return deck.calculateLands()
    }

    var totalLands: Int {
        Int(Double(selectedDeckSize.cardCount) * landRatio)
    }

    var totalSpells: Int {
        Int(selectedDeckSize.cardCount) - totalLands
    }

    func updateManaPips(for color: ManaColor, value: Int) {
        manaPips[color] = max(0, value) // Prevent negative values
    }

    /// This "better custom binding" method was suggested by
    /// Brandon Williams on BlueSky:
    /// https://bsky.app/profile/mbrandonw.bsky.social/post/3lbkgd3e5tc2y
    subscript(pipCountFor color: ManaColor) -> Int {
        get { manaPips[color] ?? 0 }
        set { updateManaPips(for: color, value: newValue) }    }
}
