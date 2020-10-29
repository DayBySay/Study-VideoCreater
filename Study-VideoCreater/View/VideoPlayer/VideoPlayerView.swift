//
//  VideoPlayerView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/29.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    var videoURL: URL?

    private var player: AVPlayer? {
        guard let url = videoURL else { return nil}
        return AVPlayer(url: url)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
