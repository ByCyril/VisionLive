//
//  LiveVisionView.swift
//  VisionLive
//
//  Created by Cyril Garcia on 10/19/18.
//  Copyright © 2018 Cyril Garcia. All rights reserved.
//

import UIKit

class LiveVisionView: UIView {
    
    private var resultsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        self.addElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        let size = CGSize(width: self.frame.width - 50, height: 100)
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height * 0.90)
        
        self.resultsLabel = {
            let label = UILabel()
            label.frame.size = size
            label.center = center
            label.textAlignment = .center
            label.backgroundColor = UIColor.lightText
            label.textColor = UIColor.black
            label.font = UIFont(name: "System", size: 17)
            label.clipsToBounds = true
            label.numberOfLines = 10
            label.layer.cornerRadius = 10
            label.layer.zPosition = 5
            return label
        }()
    }
    
    private func addElements() {
        self.addSubview(self.resultsLabel)
    }
    
    public func display(text: String) {
        self.resultsLabel.text = text
    }
    
    
}
