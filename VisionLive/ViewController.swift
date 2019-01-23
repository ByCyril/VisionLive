//
//  ViewController.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/17/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageSet = ImageSet().model
    
    var liveVision: LiveVision!
    var visionView: VisionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setup()
       
    }
    
    private func setup() {
        // Initiate the VisionView and LiveVision classes
        self.visionView = VisionView(frame: self.view.frame)
        self.liveVision = LiveVision(model: self.imageSet)
        
        // Create a preview layer where the video feed will play
        let previewLayer = self.liveVision.previewLayer(frame: self.view.frame)
        // Add the preview layer as a sub layer of the VisionView class
        self.visionView.layer.addSublayer(previewLayer)
        
        // Set the delegate to the super class and start the camera
        self.liveVision.delegate = self
        self.liveVision.startCamera()
        
        // Ass the VisionView as a subview to the super class
        self.view.addSubview(self.visionView)
    }
    
    
}

extension ViewController: LiveVisionDelegate {
    // Gets the predicted item and displays it
    func getPrediction(prediction: String, confidenceLevel: Double) {
        self.visionView.display(text: "Item: \(prediction)\n\nConfidence Level: \(confidenceLevel)%")
    }
}
