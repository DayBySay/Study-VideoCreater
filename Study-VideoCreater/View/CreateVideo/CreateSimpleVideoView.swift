//
//  CreateSimpleVideoView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/28.
//

import SwiftUI

struct CreateSimpleVideoView: View {
    @StateObject var viewModel = CreateVideoViewModel()
    
    var body: some View {
        Button("Create Video") {
            viewModel.createVideo()
        }
        VideoPlayerView(videoURL: viewModel.url)
            .frame(width: 320, height: 320, alignment: .center)
    }
}

import AVFoundation

class CreateVideoViewModel: ObservableObject {
    @Published var url: URL? = nil
    
    private let videoCreator = VideoCreator()
    
    func createVideo() {
        url = videoCreator.createVideoFromImage()
    }

}

struct CreateVideoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSimpleVideoView()
    }
}
