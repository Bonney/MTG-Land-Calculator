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

    var body: some View {
        HStack {
            Label {
                Text(color.rawValue.capitalized)
            } icon: {
                color.symbolImage
            }
            .frame(width: 100, alignment: .leading)

            /// This "better custom binding" method was suggested by
            /// Brandon Williams on BlueSky:
            /// https://bsky.app/profile/mbrandonw.bsky.social/post/3lbkgd3e5tc2y
            Stepper(
                value: $viewModel[pipCountFor: color],
                in: 0...Int.max) {
                    Text("×\(viewModel.manaPips[color] ?? 0)")
                }
        }
    }
}
