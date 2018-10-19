//
//  ViewController.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/17/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LiveVisionDelegate {
    
    let resnetModel = Resnet50().model
    
    var liveVision: LiveVision!
    var liveVisionView: LiveVisionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.liveVisionView = LiveVisionView(frame: self.view.frame)
        
        self.liveVision = LiveVision(model: self.resnetModel)
        self.liveVision.delegate = self
        
        let previewLayer = self.liveVision.previewLayer(frame: self.view.layer.bounds)
        self.liveVisionView.layer.addSublayer(previewLayer)
        self.liveVision.startCamera()
        
        self.view.addSubview(self.liveVisionView)
    }
    
    func getPrediction(prediction: String, confidenceLevel: Double) {
        self.liveVisionView.display(text: "\(prediction), \(confidenceLevel)")
    }
}

