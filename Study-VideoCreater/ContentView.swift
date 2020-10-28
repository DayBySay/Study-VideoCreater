//
//  ContentView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/28.
//

import SwiftUI

let items = [
    DetailViewItem(name: "hoge"),
    DetailViewItem(name: "fuga"),
    DetailViewItem(name: "nyossu"),
]

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListView()
        }
    }
}

struct ListView: View {
    var body: some View {
        List(items) { item in
            NavigationLink(
                destination: DetailView(item: item),
                label: {
                    Text(item.name)
                })
        }
        .navigationBarTitle("Create Media")
    }
}

struct DetailView: View {
    var item: DetailViewItem

    var body: some View {
        VStack {
            Text(item.name)
        }
        .navigationBarTitle(item.name)
    }
}

struct DetailViewItem: Equatable, Identifiable {
    var id: String { name }
    let name: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
