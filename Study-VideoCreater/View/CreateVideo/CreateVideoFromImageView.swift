//
//  CreateVideoFromImageView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/28.
//

import SwiftUI

struct CreateVideoFromImageView: View {
    @StateObject var viewModel = CreateVideoFromImageViewModel()
    
    var body: some View {
        Button("Create Video From Image") {
            viewModel.createVideo()
        }
        VideoPlayerView(videoURL: viewModel.url)
            .frame(width: 320, height: 320, alignment: .center)
    }
}

class CreateVideoFromImageViewModel: ObservableObject {
    @Published var url: URL?
    
    private let videoCreator = VideoCreator()
    
    func createVideo() {
        url = videoCreator.createVideoFromImage()
    }
}

struct CreateVideoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateVideoFromImageView()
    }
}
