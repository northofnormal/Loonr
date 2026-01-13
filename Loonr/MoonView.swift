//
//  MoonView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import AlarmKit
import Combine
import SwiftUI
import MapKit
import ActivityKit

class MoonViewModel: ObservableObject {
    @Published var moonData: MoonData?

    func fetchMoonData() {
        Task {
            moonData = try await MoonAPI().fetchMoonData(latitude: "\(LocationManager.shared.region.center.latitude)", longitude: "\(LocationManager.shared.region.center.latitude)")
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
        guard let phase = moonData?.moonphaseText else { return "moonphase.new.moon" }
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
            Task {
                let stuff = try await  MoonAPI().fetchMoonData(latitude: "\(LocationManager.shared.region.center.latitude)", longitude: "\(LocationManager.shared.region.center.latitude)")
            }

        }
    }
}
