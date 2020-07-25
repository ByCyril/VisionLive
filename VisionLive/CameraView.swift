//
//  CameraView.swift
//  VisionLive
//
//  Created by Cyril Garcia on 7/25/20.
//  Copyright © 2020 Cyril Garcia. All rights reserved.
//

import UIKit
import AVKit

protocol CameraViewDelegate: AnyObject {
    func cameraFeed(_ sampleBuffer: CMSampleBuffer)
}

final class CameraView: UIView {
    
    var captureSession: AVCaptureSession?
    
    weak var delegate: CameraViewDelegate?
    
    var resultsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = UIColor.lightText
        label.textColor = UIColor.black
        label.font = UIFont(name: "System", size: 20)
        label.clipsToBounds = true
        label.numberOfLines = 2
        label.layer.cornerRadius = 10
        label.layer.zPosition = 5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCaptureSession()
        previewLayer()
        setupResultsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let dataInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(dataInput)
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_queue"))
            captureSession?.addOutput(dataOutput)
            
        } catch {
            print("Error",error.localizedDescription)
        }
    }
    
    private func previewLayer() {
        guard let captureSession = self.captureSession else { return }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = frame
        
        layer.addSublayer(previewLayer)
    }
    
    private func setupResultsView() {
        addSubview(resultsLabel)
        NSLayoutConstraint.activate([
            resultsLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            resultsLabel.heightAnchor.constraint(equalToConstant: 150),
            resultsLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            resultsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        layoutIfNeeded()
    }
    
}

extension CameraView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.cameraFeed(sampleBuffer)
    }
}
