//
//  ContentView.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/24/24.
//

import SwiftUI
import Backpack

struct DeckBuilderView: View {
  @State private var viewModel = DeckViewModel()

  var body: some View {
    NavigationStack {
      List {
        deckSection
        manaSymbolSection
        suggestedLandsSection
      }
      .listStyle(.plain)
      .headerProminence(.increased)
      .navigationTitle("Land Calculator")
      .toolbarTitleDisplayMode(.inline)
      .monospacedDigit()
      .contentTransition(.numericText())
      .animation(.smooth, value: viewModel.calculatedLands)
    }
  }

  var deckSection: some View {
    Section {
      Picker("Deck Size", selection: $viewModel.selectedDeckSize) {
        ForEach(DeckSize.allCases, id: \.self) { size in
          Text("\(size.rawValue) (\(size.cardCount.formatted()))").tag(size)
        }
      }
      HStack {
        VStack {
          Text(viewModel.totalSpells.formatted()).foregroundStyle(.primary)
          Text("Spells").foregroundStyle(.secondary)
        }

        Slider(value: $viewModel.landRatio, in: 0.0...1.0, step: 0.01)

        VStack {
          Text(viewModel.totalLands.formatted()).foregroundStyle(.primary)
          Text("Lands").foregroundStyle(.secondary)
        }
      }
    }
  }

  var manaSymbolSection: some View {
    Section("Mana Symbols") {
      ForEach(ManaColor.allCases, id: \.self) { color in
        CustomStepper(color: color, viewModel: viewModel)
      }
    }
  }

  var suggestedLandsSection: some View {
    Section("Suggested Land") {
      ForEach(ManaColor.allCases, id: \.self) { color in
        let count: Int = (viewModel.calculatedLands[color] ?? 0)

        HStack {
          color.symbolImage
          Text(count, format: .number.precision(.integerLength(2))).monospaced()
          Text(color.landName)
        }
      }
    }
  }
}

#Preview {
  DeckBuilderView()
}
