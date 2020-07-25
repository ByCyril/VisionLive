//
//  VisionRecognizer.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/25/20.
//  Copyright © 2020 Cyril Garcia. All rights reserved.
//

import UIKit
import Vision
import AVKit

protocol VisionRecognizerDelegate: AnyObject {
    func prediction(_ identifier: String,_ confidenceLevel: Double)
}

final class VisionRecognizer {
    weak var delegate: VisionRecognizerDelegate?
    
    private var model: VNCoreMLModel
    var confidenceLevelTolerance: Double = 0.6
    
    init(model: MLModel) {
        self.model = try! VNCoreMLModel(for: model)
    }
    
    func predict(from sampleBuffer: CMSampleBuffer) {
        do {
            guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            
            let request = VNCoreMLRequest(model: model) { (finishRequest, error) in
                
                let results = finishRequest.results as? [VNClassificationObservation]
                
                let firstObservation = results!.first
                
                let confidenceLevel = Double(firstObservation!.confidence)
                let identifier = firstObservation!.identifier
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if confidenceLevel >= self.confidenceLevelTolerance {
                        self.delegate?.prediction(identifier, confidenceLevel)
                    }
                }
            }
            
            try requestHandler.perform([request])
            
        } catch {
            print("Error", error.localizedDescription)
        }
    }
}
