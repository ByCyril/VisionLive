//
//  ViewController.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/17/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LiveVisionDelegate {
    
    let imageSet = ImageSet().model
    
    var liveVision: LiveVision!
    var liveVisionView: LiveVisionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.liveVisionView = LiveVisionView(frame: self.view.frame)
        self.liveVision = LiveVision(model: self.imageSet)

        let previewLayer = self.liveVision.previewLayer(frame: self.view.frame)
        self.liveVisionView.layer.addSublayer(previewLayer)
        
        self.liveVision.delegate = self
        self.liveVision.startCamera()
        
        self.view.addSubview(self.liveVisionView)
    }
    
    func getPrediction(prediction: String, confidenceLevel: Double) {
        self.liveVisionView.display(text: "Item: \(prediction)\n\nConfidence Level: \(confidenceLevel)%")
    }
}

