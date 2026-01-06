//
//  MoonAPI.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import Foundation

struct MoonAPI {

    func fetchMoonData() async throws -> MoonData? {
        var urlComponents = URLComponents(string: "https://api.stormglass.io/v2/astronomy/point")
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: "41.4562"),
            URLQueryItem(name: "lng", value: "-82.7117")
        ]

        guard let moonURL = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: 0)
        }

        var request = URLRequest(url: moonURL)
        request.setValue("df14bbb4-ea9b-11f0-a148-0242ac130003-df14bc54-ea9b-11f0-a148-0242ac130003", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(MoonData.self, from: data)
            return response
        } catch {
            print("ERROR: \(error)")
        }

        return nil
    }
}
