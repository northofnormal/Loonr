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

    func convertToReadable(date: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: date) {
            let readableDateString = date.formatted(date: .abbreviated, time: .shortened)
            return (readableDateString)
        }

        return nil
    }

    func covertToMoonSymbol() -> String {
        guard let phase = moonData?.moonphaseText else { return "moonphase.newmoon" }
        let downString = phase.lowercased()
        let noSpacesString = downString.replacingOccurrences(of: " ", with: ".")
        let sfSymbolsString = "moonphase." + noSpacesString

        return sfSymbolsString
    }

}

struct MoonView: View {
    @StateObject var viewModel = MoonViewModel()

    var body: some View {
        VStack(spacing: 10) {

            Image(systemName: viewModel.covertToMoonSymbol())
                .font(.system(size: 100))

            Text(viewModel.moonData?.moonphaseText ?? "Loading...")
                .font(Font.largeTitle.bold())

            if let moonData = viewModel.moonData {
                Text("Moon Rise: \(viewModel.convertToReadable(date: moonData.moonrise) ?? "")")
                Text("Moon Set: \(viewModel.convertToReadable(date: moonData.moonset) ?? "")")
            }

            Spacer()
        }
        .padding(10)
        .onAppear {
            viewModel.fetchMoonData()
        }
    }
}
