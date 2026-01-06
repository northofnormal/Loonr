//
//  MoonData.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import Foundation
struct MoonData: Codable {
    let moonrise: String
    let moonset: String
    let moonphaseText: String

    enum CodingKeys: String, CodingKey {
        case data
    }

    enum DataKeys: String, CodingKey {
        case moonrise
        case moonset
        case moonPhase
    }

    enum MoonPhaseKeys: String, CodingKey {
        case current
    }

    enum CurrentKeys: String, CodingKey {
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var dataArray = try container.nestedUnkeyedContainer(forKey: .data)
        let dataContainer = try dataArray.nestedContainer(keyedBy: DataKeys.self)

        moonrise = try dataContainer.decode(String.self, forKey: .moonrise)
        moonset = try dataContainer.decode(String.self, forKey: .moonset)

        let moonPhaseContainer = try dataContainer.nestedContainer(keyedBy: MoonPhaseKeys.self, forKey: .moonPhase)
        let currentContainer = try moonPhaseContainer.nestedContainer(keyedBy: CurrentKeys.self, forKey: .current)
        moonphaseText = try currentContainer.decode(String.self, forKey: .text)
    }

    func encode(to encoder: any Encoder) throws {
        // for conformance
    }
}
