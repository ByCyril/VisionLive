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

class ViewController: UIViewController {
    
    let techModel = Tech().model
    let resnetModel = Resnet50().model
    let p_layer = AVCaptureVideoPreviewLayer()
    var visionLive: VisionLive!
    
    @IBOutlet var results_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        visionLive = VisionLive(with: self, model: Tech().model, previewLayer: p_layer, resultsLabel: results_label)
        visionLive.setup_camera()
        
    }
}

