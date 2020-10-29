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
    private let width = 320
    private let height = 320
    private var rect: CGRect { CGRect(origin: .zero, size: CGSize(width: width, height: height)) }
    private var outputSettings: [String: Any] {
        [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: width,
            AVVideoHeightKey: height,
        ]
    }
    private var sourcePixelBufferAttributes: [String: Any] {
        [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB),
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
        ]
    }
    private let fps = 30
    private var duration: CMTime {
        CMTime(seconds: Double(10), preferredTimescale: CMTimeScale(fps))
    }

    func createSimpleVideo() -> URL? {
        let image = createColorImage(color: .red)!
        return createVideoFromImage(image: image)
    }
    
    func createVideoFromImage() -> URL? {
        let image = UIImage(named: "Image")!
        return createVideoFromImage(image: image)
    }
    
    private func createColorImage(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func createVideoFromImage(image: UIImage) -> URL? {
        let url = self.url
        guard let writer = try? AVAssetWriter(outputURL: url, fileType: .mov) else {
            print("URLがダメ")
            return nil
        }

        
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        writer.add(input)
        
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input,
                                                         sourcePixelBufferAttributes: sourcePixelBufferAttributes)
        input.expectsMediaDataInRealTime = true
        
        let ciImage = CIImage(image: image)!
        var pixelBuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault,
                            width,
                            height,
                            kCVPixelFormatType_32ARGB,
                            [
                                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
                            ] as CFDictionary,
                            &pixelBuffer)
        CIContext().render(ciImage, to: pixelBuffer!)
        
        guard writer.startWriting() else {
            print("書けないヨ")
            return nil
        }
        writer.startSession(atSourceTime: CMTime(seconds: 0, preferredTimescale: CMTimeScale(fps)))
        if !adaptor.append(pixelBuffer!, withPresentationTime: CMTime(seconds: 0, preferredTimescale: CMTimeScale(fps))) {
            print("ついかしっぱい")
        }
        if !adaptor.append(pixelBuffer!, withPresentationTime: duration) {
            print("ついかしっぱい")
        }
        
        input.markAsFinished()
        writer.endSession(atSourceTime: duration)
        writer.finishWriting {
            print("ビデオができた")
        }
        
        print("open \(NSTemporaryDirectory())")
        
        return url
    }
}
