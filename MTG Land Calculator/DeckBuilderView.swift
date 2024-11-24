//
//  ContentView.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/24/24.
//

import SwiftUI
import Backpack
import MTGSymbols
import Observation

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
}

struct CustomStepper: View {
    let color: ManaColor
    let viewModel: DeckViewModel

    var body: some View {
        HStack {
            Label {
                Text(color.rawValue.capitalized)
            } icon: {
                color.symbolImage
//                MTGText(color.symbol)
            }
            .frame(width: 100, alignment: .leading)

            Stepper(value: Binding(
                get: { viewModel.manaPips[color] ?? 0 },
                set: { viewModel.updateManaPips(for: color, value: $0) }
            ), in: 0...Int.max) {
                Text("×\(viewModel.manaPips[color] ?? 0)")
            }
        }
    }
}


struct DeckBuilderView: View {
    @State private var viewModel = DeckViewModel()

    var body: some View {
        List {
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

                    Slider(value: $viewModel.landRatio, in: 0.1...0.6, step: 0.01)

                    VStack {
                        Text(viewModel.totalLands.formatted()).foregroundStyle(.primary)
                        Text("Lands").foregroundStyle(.secondary)
                    }
                }
            }

            Section("Mana Symbols") {
                ForEach(ManaColor.allCases, id: \.self) { color in
                    CustomStepper(color: color, viewModel: viewModel)
                }
            }

            Section("Suggested Land") {
                ForEach(ManaColor.allCases, id: \.self) { color in
                    let count: Int = (viewModel.calculatedLands[color] ?? 0)

                    Label {
                        LabeledContent {
                            Text("×\(count.formatted())")
                        } label: {
                            Text(color.landName)
                        }
                    } icon: {
                        color.symbolImage
                    }
                }
            }
        }
        .listStyle(.plain)
        .headerProminence(.increased)
        .monospacedDigit()
        .contentTransition(.numericText())
        .animation(.smooth, value: viewModel.calculatedLands)
        .navigationTitle("Land Calculator")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DeckBuilderView()
    }
}
