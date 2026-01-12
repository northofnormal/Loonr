//
//  MoonView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import AlarmKit
import Combine
import SwiftUI
internal import ActivityKit

class MoonViewModel: ObservableObject {
    @Published var moonData: MoonData?
    private let alarmManager = AlarmManager.shared

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
        guard let phase = moonData?.moonphaseText else { return "moonphase.new.moon" }
        let downString = phase.lowercased()
        let noSpacesString = downString.replacingOccurrences(of: " ", with: ".")
        let sfSymbolsString = "moonphase." + noSpacesString

        return sfSymbolsString
    }

    func setMoonRiseAlarm() async {
        switch AlarmManager.shared.authorizationState {
        case .notDetermined:
            Task {
                await requestAlarmPermission()
            }
        case .authorized:
            let formatter = ISO8601DateFormatter()
            guard let moonrise = formatter.date(from: moonData?.moonrise ?? "") else {
                return // show an alert or something
            }
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: moonrise)

            let moonriseDate = Calendar.current.date(from: components)!
            let fixedAlert = Alarm.Schedule.fixed(moonriseDate)

            let stopButton = AlarmButton(
                text: "Got It!",
                textColor: .white,
                systemImageName: "moonphase.new.moon"
            )

            let alertPresentation = AlarmPresentation.Alert(
                title: "Moon Rise!",
                stopButton: stopButton
            )

            let alarmAttributes = AlarmAttributes<EmptyMetadata>(presentation: AlarmPresentation(alert: alertPresentation), tintColor: Color.brown)

            do {
                let moonriseAlarm = try await alarmManager.schedule(id: UUID(), configuration: .alarm(schedule: fixedAlert, attributes: alarmAttributes, sound: .default))
                print("successfully scheduled alarm!")
            } catch {
                print("alarm failed to schedule! \(error)")
            }

        case .denied:
            print("Denied")
        @unknown default:
            fatalError()
        }
    }

    private func requestAlarmPermission() async -> Bool {
        switch alarmManager.authorizationState {
        case .notDetermined:
            do {
                return try await alarmManager.requestAuthorization() == .authorized
            } catch {
                return false
            }
        case .authorized:
            return true
        case .denied:
            return false

        @unknown default:
            return false
        }
    }

}

nonisolated
struct EmptyMetadata: AlarmMetadata{
    // Empty implementation
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

            Button {
                Task {
                    await viewModel.setMoonRiseAlarm()
                }
            } label: {
                Text("Set Moon Rise Alarm")
            }
            .buttonStyle(LargeButtonStyle())
        }
        .padding(10)
        .onAppear {
            viewModel.fetchMoonData()
        }
    }
}
