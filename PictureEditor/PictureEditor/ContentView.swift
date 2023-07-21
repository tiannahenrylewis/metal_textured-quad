//
//  ContentView.swift
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                MetalView().border(Color.gray, width: 2)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
