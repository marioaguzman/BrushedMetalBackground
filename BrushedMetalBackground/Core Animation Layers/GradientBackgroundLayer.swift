//
//  GradientBackgroundLayer.swift
//  BrushedMetalBackground
//
//  Created by Mario Guzman on 5/30/24.
//

import Cocoa

final class GradientBackgroundLayer: CALayer {
    
    private var grayGradientBackgroundLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
                layer.colors = [NSColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 185.0/255.0, green: 185.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 185.0/255.0, green: 185.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor,
                                NSColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1.0).cgColor
                ]
                layer.locations = [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1.0] as [NSNumber]
                layer.startPoint = CGPoint(x: 0.0, y: 0.5)
                layer.endPoint = CGPoint(x: 1.0, y: 0.5)
                layer.actions = nil
                return layer
    }()
    
    override init(layer: Any) {
        super.init(layer: layer)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.masksToBounds = false
        self.addSublayer(self.grayGradientBackgroundLayer)
    }
    
    override func layoutSublayers() {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.grayGradientBackgroundLayer.frame = self.bounds
        CATransaction.commit()
    }
    
    func updateBackingProperties(contentScale: CGFloat) {
        self.grayGradientBackgroundLayer.contentsScale = contentScale
    }
}
