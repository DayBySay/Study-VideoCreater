//
//  CreateSimpleVideoView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/30.
//

import SwiftUI

struct CreateSimpleVideoView: View {
    @StateObject var viewModel = CreateSimpleVideoViewModel()
    
    var body: some View {
        Button("Create Simple Video") {
            viewModel.createVideo()
        }
        VideoPlayerView(videoURL: viewModel.url)
            .frame(width: 320, height: 320, alignment: .center)
    }
}

class CreateSimpleVideoViewModel: ObservableObject {
    @Published var url: URL?
    
    private let videoCreator = VideoCreator()
    
    func createVideo() {
        url = videoCreator.createSimpleVideo()
    }
}

struct CreateSimpleVideoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSimpleVideoView()
    }
}
