//
//  MapView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var manager = LocationManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        Map(position: $position) {
            if manager.permission == .authorizedWhenInUse || manager.permission == .authorizedAlways {
                UserAnnotation()
            }
        }
        .mapControls {
            MapScaleView()
            MapCompass()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.brown, lineWidth: 5)
        )
        .padding()
    }

}

#Preview {
    MapView()
}
