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
        let url = self.url
        guard let writer = try? AVAssetWriter(outputURL: url, fileType: .mov) else {
            print("URLがダメ")
            return nil
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
        
        let fps = 30
        let duration = CMTime(seconds: Double(10), preferredTimescale: CMTimeScale(fps))
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIColor.red.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

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
    
    func createVideoFromImage() -> URL? {
        let url = self.url
        guard let writer = try? AVAssetWriter(outputURL: url, fileType: .mov) else {
            print("URLがダメ")
            return nil
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
        
        let fps = 30
        let duration = CMTime(seconds: Double(10), preferredTimescale: CMTimeScale(fps))
        let image = UIImage(named: "Image")!
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
