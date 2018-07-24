//
//  ViewController.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/17/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let model = try? VNCoreMLModel(for: Tech().model)
    
    var p_layer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet var results_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup_camera()
        
    }
    
 
    func setup_camera() {
        let capture_session = AVCaptureSession()
        let capture_device = AVCaptureDevice.default(for: .video)
        let input = try? AVCaptureDeviceInput(device: capture_device!)
        
        capture_session.addInput(input!)
        capture_session.startRunning()
        
        let preview_layer = AVCaptureVideoPreviewLayer(session: capture_session)
        self.view.layer.addSublayer(preview_layer)
        p_layer = preview_layer
        
        preview_layer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        let data_output = AVCaptureVideoDataOutput()
        data_output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_queue"))
        
        capture_session.addOutput(data_output)
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let pixel_buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let request = VNCoreMLRequest(model: model!) { (finish_request, err) in
            

            
            let results = finish_request.results as? [VNClassificationObservation]
            
            let first_observation = results!.first
            
            let prediction = "Detected Object: \(first_observation!.identifier)\nConfidence Level: \(round(first_observation!.confidence * 100))%"
            
            DispatchQueue.main.async {
                self.results_label.layer.zPosition = 100
                self.results_label.numberOfLines = 2
                self.results_label.frame.size.height = 75
                self.results_label.textAlignment = .center
                self.results_label.backgroundColor = UIColor.green
                self.results_label.text = prediction

            }
            
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixel_buffer, options: [:]).perform([request])
    }
    
    
    
}

