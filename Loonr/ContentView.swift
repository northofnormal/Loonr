//
//  ContentView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showingMoonSheet = false
    @State private var showingMeetSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: MapView()) {
                    Text("Map 🗺️")
                        .font(.system(.title))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundStyle(Color.white)
                        .clipShape(Capsule())
                }

                Button {
                    showingMoonSheet.toggle()
                } label: {
                    Text("Moon 🌕")
                }
                .buttonStyle(LargeButtonStyle())

                Button {
                    showingMeetSheet.toggle()
                } label: {
                    Text("Meet 🐾")
                }
                .buttonStyle(LargeButtonStyle())

            }
            .padding()
        }
        .sheet(isPresented: $showingMoonSheet) {
            MoonView()
        }
        .sheet(isPresented: $showingMeetSheet) {
            MeetView()
        }
    }
}

#Preview {
    ContentView()
}
