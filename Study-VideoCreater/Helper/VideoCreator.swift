//
//  VideoCreator.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/30.
//

import UIKit
import AVFoundation

struct VideoCreator {
    private var url: URL { URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).mov") }

    func createSimpleVideo() -> URL? {
        let configuration = VideoConfiguration.makeDefault()
        let image = createColorImage(color: .red, rect: configuration.rect)!
        return createVideoFromImage(configuration: configuration, image: image)
    }
    
    func createVideoFromImage() -> URL? {
        let image = UIImage(named: "Image")!
        return createVideoFromImage(configuration: VideoConfiguration.makeDefault(), image: image)
    }
    
    private func createColorImage(color: UIColor, rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createVideoFromImage(configuration: VideoConfiguration, image: UIImage) -> URL? {
        let url = self.url
        guard let writer = try? AVAssetWriter(outputURL: url, fileType: .mov) else {
            return nil
        }
        
        let asset = AVAsset(url: Bundle.main.url(forResource: "engawa", withExtension: "mp3")!)
        let reader = try! AVAssetReader(asset: asset)
        let audioOutputSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVSampleRateKey: 48000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsNonInterleaved: false,
        ]
        let trackOutput = AVAssetReaderTrackOutput(track: asset.tracks[0],
                                                   outputSettings: audioOutputSettings)
        reader.add(trackOutput)
        let audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
        writer.add(audioInput)

        // VideoTrack追加用のInputを作成しWriterに追加
        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: configuration.outputSettings)
        writer.add(videoInput)
        
        // CVPixelBufferから書き込むのでAdaptorを作成
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoInput,
                                                           sourcePixelBufferAttributes: configuration.sourcePixelBufferAttributes)
        
        // videoに書き込むためのバッファを作成
        let ciImage = CIImage(image: image)!
        var pixelBuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            Int(configuration.rect.width),
                            Int(configuration.rect.height),
                            kCVPixelFormatType_32ARGB,
                            [
                                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
                            ] as CFDictionary,
                            &pixelBuffer)
        CIContext().render(ciImage, to: pixelBuffer!)

        // 書き込み可能かどうかの確認
        guard writer.startWriting() else { return nil }
        writer.startSession(atSourceTime: CMTime(seconds: 0, preferredTimescale: CMTimeScale(configuration.fps)))

        reader.startReading()
        while reader.status == .reading {
            guard let buffer = trackOutput.copyNextSampleBuffer() else  { continue }
            if audioInput.isReadyForMoreMediaData {
                audioInput.append(buffer)
            }
        }

        adaptor.append(pixelBuffer!, withPresentationTime: CMTime(seconds: 0, preferredTimescale: CMTimeScale(configuration.fps)))
        adaptor.append(pixelBuffer!, withPresentationTime: configuration.duration)
        
        videoInput.markAsFinished()
        writer.endSession(atSourceTime: configuration.duration)
        writer.finishWriting {
            print("ビデオ完成")
        }
        
        print("open \(NSTemporaryDirectory())")
        
        return url
    }
}

struct VideoConfiguration {
    var rect: CGRect
    var outputSettings: [String: Any]
    var sourcePixelBufferAttributes: [String: Any]
    var fps: Int
    var duration: CMTime
    
    static func makeDefault() -> VideoConfiguration {
        let width = 320
        let height = 320
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        let outputSettings: [String: Any] =
            [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: width,
                AVVideoHeightKey: height,
            ]
        
        let sourcePixelBufferAttributes: [String: Any] =
            [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: width,
                kCVPixelBufferHeightKey as String: height,
            ]
        let fps = 30
        let duration: CMTime = CMTime(seconds: Double(10), preferredTimescale: CMTimeScale(fps))
        
        return VideoConfiguration(rect: rect, outputSettings: outputSettings, sourcePixelBufferAttributes: sourcePixelBufferAttributes, fps: fps, duration: duration)
    }
}
