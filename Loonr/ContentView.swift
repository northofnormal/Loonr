//
//  ContentView.swift
//  Loonr
//
//  Created by Anne Cahalan on 1/5/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                // do a thing
            } label: {
                Text("Map 🗺️")
            }
            .buttonStyle(LargeButtonStyle())

            Button {
                // do a thing
            } label: {
                Text("Moon 🌕")
            }
            .buttonStyle(LargeButtonStyle())

            Button {
                // do a thing
            } label: {
                Text("Meet 🐾")
            }
            .buttonStyle(LargeButtonStyle())

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
