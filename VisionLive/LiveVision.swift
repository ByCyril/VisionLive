//
//  VisionLive.swift
//  VisionLive
//
//  Created by Cyril Garcia on 8/6/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit
import Vision
import AVKit

protocol LiveVisionDelegate {
    func getPrediction(prediction: String, confidenceLevel: Double)
}

class LiveVision: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var model: VNCoreMLModel!
    private var prediction = ""
    private var captureSession: AVCaptureSession!
    
    public var delegate: LiveVisionDelegate!
    
    init(model: MLModel) {
        super.init()
        self.model = try? VNCoreMLModel(for: model)
        self.setupCaptureSession()
    }
    
    private func setupCaptureSession() {
        self.captureSession = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: .video)
        let input = try? AVCaptureDeviceInput(device: captureDevice!)
        self.captureSession.addInput(input!)
        
        let data_output = AVCaptureVideoDataOutput()
        data_output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_queue"))
        self.captureSession.addOutput(data_output)
    }
    
    public func previewLayer(frame: CGRect) -> AVCaptureVideoPreviewLayer {
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        previewLayer.frame = frame
        
        return previewLayer
        
    }
    
    public func startCamera() {
        self.captureSession.startRunning()
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let request = VNCoreMLRequest(model: self.model!) { (finishRequest, err) in
            
            let results = finishRequest.results as? [VNClassificationObservation]
            
            let firstObservation = results!.first

            let confidenceLevel = Double(round(firstObservation!.confidence * 100))
            let identifier = firstObservation!.identifier
            
            DispatchQueue.main.async {
                if confidenceLevel >= 60.0 {
                    self.delegate.getPrediction(prediction: identifier, confidenceLevel: confidenceLevel)
                }
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }

}
