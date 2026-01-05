//
//  LargeButtonStyle.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import SwiftUI

struct LargeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.title))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.brown)
            .foregroundStyle(Color.white)
            .clipShape(Capsule())
    }
}
