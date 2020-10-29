//
//  ContentView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/28.
//

import SwiftUI

struct DestinatioItem: Identifiable {
    var id: String { name }
    let name: String
    let view: AnyView
}

let destinationItems: [DestinatioItem] = [
    DestinatioItem(name: "hoge", view: AnyView(DetailView(item: DetailViewItem(name: "hoge")))),
    DestinatioItem(name: "fuga", view: AnyView(DetailView(item: DetailViewItem(name: "fuga")))),
    DestinatioItem(name: "nyassu", view: AnyView(DetailView(item: DetailViewItem(name: "nyaosu")))),
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
        List(destinationItems) { item in
            NavigationLink(
                destination: item.view,
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
