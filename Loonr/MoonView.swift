//
//  MoonView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import Combine
import SwiftUI

class MoonViewModel: ObservableObject {
    @Published var moonData: MoonData?

    func fetchMoonData() {
        Task {
            moonData = try await MoonAPI().fetchMoonData()
        }
    }
}

struct MoonView: View {
    @StateObject var viewModel = MoonViewModel()

    var body: some View {
        Text("Hello Moon!")
            .onAppear {
                viewModel.fetchMoonData()
            }
    }
}
