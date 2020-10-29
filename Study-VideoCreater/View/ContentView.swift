//
//  ContentView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListView()
        }
    }
}

struct ListView: View {
    var body: some View {
        Form {
            Section(header: Text("Create Media")) {
                NavigationLink("Create Simple Video", destination: CreateSimpleVideoView())
                NavigationLink("Create Video From Image", destination: CreateVideoFromImageView())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
