//
//  CreateVideoView.swift
//  Study-VideoCreater
//
//  Created by Takayuki Sei on 2020/10/28.
//

import SwiftUI

struct CreateSimpleVideoView: View {
    let viewModel = CreateVideoViewModel()
    
    var body: some View {
        Button("Create Video") {
            viewModel.createVideo()
        }
    }
}

import AVFoundation

class CreateVideoViewModel {
    func createVideo() {
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output.mov")!
        guard let writer = try? AVAssetWriter(outputURL: url, fileType: .mov) else {
            print("URLがダメポ")
            return
        }
        
        let width = 320
        let height = 320
        
        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
        ]
        
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        writer.add(input)
        
        let attr: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
        ]

        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
                                                         sourcePixelBufferAttributes: attr)
        input.expectsMediaDataInRealTime = true
        
        guard writer.startWriting() else {
            print("書けないヨ")
            return
        }
        
        writer.startSession(atSourceTime: CMTime.zero)
        
        let fps: __int32_t = 60
        let duration = CMTime(seconds: Double(10 * Int(fps)), preferredTimescale: fps)
        let image = UIImage(named: "Image")!
        let ciImage = CIImage(image: image)!
        var pixelBuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32BGRA,
                            [
                                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
                            ] as CFDictionary,
                            &pixelBuffer)
        CIContext().render(ciImage, to: pixelBuffer!)
        if !adaptor.append(pixelBuffer!, withPresentationTime: duration) {
            print("arara")
        }
        
        input.markAsFinished()
        writer.endSession(atSourceTime: duration)
        writer.finishWriting {
            print("ビデオができたお")
        }
        
        print(url)
    }
}

struct CreateVideoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSimpleVideoView()
    }
}
