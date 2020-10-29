//
//  CreateSimpleVideoWithAudioView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/30.
//

import SwiftUI

struct CreateSimpleVideoWithAudioView: View {
    @StateObject var viewModel = CreateSimpleVideoWithAudioViewModel()
    
    var body: some View {
        Button("Create Simple Video With Audio") {
            viewModel.createVideo()
        }
        VideoPlayerView(videoURL: viewModel.url)
            .frame(width: 320, height: 320, alignment: .center)
    }
}

class CreateSimpleVideoWithAudioViewModel: ObservableObject {
    @Published var url: URL?
    
    private let videoCreator = VideoCreator()
    
    func createVideo() {
        url = videoCreator.createVideoFromImage()
    }
}

struct CreateSimpleVideoWithAudioView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSimpleVideoWithAudioView()
    }
}
