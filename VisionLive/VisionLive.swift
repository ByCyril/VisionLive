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

class VisionLive: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private var vc: UIViewController!
    private var model: VNCoreMLModel!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var resultsLabel: UILabel!
    
    init(with vc: UIViewController, model: MLModel, previewLayer: AVCaptureVideoPreviewLayer, resultsLabel: UILabel) {
        
        self.vc = vc
        self.previewLayer = previewLayer
        self.resultsLabel = resultsLabel
        self.model = try? VNCoreMLModel(for: model)
        
    }
    
    public func setup_camera() {
        let capture_session = AVCaptureSession()
        let capture_device = AVCaptureDevice.default(for: .video)
        let input = try? AVCaptureDeviceInput(device: capture_device!)
        
        capture_session.addInput(input!)
        capture_session.startRunning()
        
        let preview_layer = AVCaptureVideoPreviewLayer(session: capture_session)
        self.vc.view.layer.addSublayer(preview_layer)
        previewLayer = preview_layer
        
        preview_layer.frame = CGRect(x: 0, y: 0, width: self.vc.view.frame.size.width, height: self.vc.view.frame.size.height)
        
        let data_output = AVCaptureVideoDataOutput()
        data_output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_queue"))
        
        capture_session.addOutput(data_output)
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let pixel_buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let request = VNCoreMLRequest(model: model!) { (finish_request, err) in
            
            let results = finish_request.results as? [VNClassificationObservation]
            
            let first_observation = results!.first
            
            let confidenceLevel = round(first_observation!.confidence * 100)
            var prediction: String!
            
            if confidenceLevel >= 60 {
                prediction   = "Detected Object: \(first_observation!.identifier)\nConfidence Level: \(round(first_observation!.confidence * 100))%"
            } else {
                prediction = "Not sure..."
            }
            
            DispatchQueue.main.async {
                self.resultsLabel.layer.zPosition = 100
                self.resultsLabel.numberOfLines = 2
                self.resultsLabel.frame.size.height = 75
                self.resultsLabel.textAlignment = .center
                self.resultsLabel.backgroundColor = UIColor.green
                self.resultsLabel.text = prediction
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixel_buffer, options: [:]).perform([request])
    }
    
}
