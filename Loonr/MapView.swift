//
//  MapView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {
    @StateObject var manager = LocationManager.shared

    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var pinnedLocations: [PinnedLocation] = []
    @State private var temporaryLocation: CLLocationCoordinate2D?

    var body: some View {
        MapReader { proxy in
            Map(position: $position, selection: .constant(nil)) {
                if manager.permission == .authorizedWhenInUse || manager.permission == .authorizedAlways {
                    UserAnnotation()
                }

                ForEach(pinnedLocations) { location in
                    Marker("Pants", coordinate: location.coordinate)
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if let pinLocation = proxy.convert(value.startLocation, from: .local) {
                            temporaryLocation = pinLocation
                        }
                    }
                    .simultaneously(with: LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            if let location = temporaryLocation {
                                pinnedLocations.append(PinnedLocation(coordinate: location))
                                temporaryLocation = nil
                            }
                        }
                    )
            )
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

}

#Preview {
    MapView()
}
