//
//  CustomStepper.swift
//  MTG Land Calculator
//
//  Created by Matt Bonney on 11/25/24.
//

import SwiftUI

struct CustomStepper: View {
  let color: ManaColor
  @Bindable var viewModel: DeckViewModel

  var count: Int {
    return (viewModel.manaPips[color] ?? 0)
  }

  var body: some View {
    /// This "better custom binding" method was suggested by
    /// Brandon Williams on BlueSky:
    /// https://bsky.app/profile/mbrandonw.bsky.social/post/3lbkgd3e5tc2y
    Stepper(value: $viewModel[pipCountFor: color], in: 0...Int.max) {
      HStack {
        color.symbolImage
        Text(count, format: .number.precision(.integerLength(2))).monospaced()
        Text(color.rawValue.capitalized)
      }
    }
  }
}

#Preview {
  CustomStepper(
    color: ManaColor.blue,
    viewModel: DeckViewModel()
  )
  .padding()
}
