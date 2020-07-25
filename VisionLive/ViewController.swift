//
//  ViewController.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/17/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    let imageSet = ImageSet().model
    
    var cameraView: CameraView?
    var visionRecognizer: VisionRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraView = CameraView(frame: view.bounds)
        cameraView?.delegate = self
        cameraView?.captureSession?.startRunning()
        view = cameraView!
        
        visionRecognizer = VisionRecognizer(model: imageSet)
        visionRecognizer?.delegate = self
    }
}

extension ViewController: CameraViewDelegate {
    func cameraFeed(_ sampleBuffer: CMSampleBuffer) {
        visionRecognizer?.predict(from: sampleBuffer)
    }
}

extension ViewController: VisionRecognizerDelegate {
    func prediction(_ identifier: String, _ confidenceLevel: Double) {
        cameraView?.resultsLabel.text = identifier + "\n \(confidenceLevel)"
    }
}
