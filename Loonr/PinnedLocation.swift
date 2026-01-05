//
//  PinnedLocation.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import CoreLocation
import Foundation

struct PinnedLocation: Identifiable {
    let id: UUID = UUID()
    var coordinate: CLLocationCoordinate2D
}
