//
//  BrushedMetalView.swift
//  BrushedMetalBackground
//
//  Created by Mario Guzman on 2/1/24.
//

import Cocoa

class BrushedMetalView: NSView {
    
    private let containerLayer: CALayer = {
        let layer = CALayer()
        layer.transform = CATransform3DMakeScale(1.0, -1.0, 1.0)
        return layer
    }()
    
    private var brushedMetalTextureLayer: BrushedMetalTextureLayer = {
        let layer = BrushedMetalTextureLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 128, height: 128)
        return layer
    }()
    
    private var gradientBackgroundLayer: GradientBackgroundLayer = {
        let layer = GradientBackgroundLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: 128, height: 128)
        return layer
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        self.setupLayers()
    }
    
    private func setupLayers() {
        // You need a container layer to use `CAConstraintLayoutManager`
        // It does not work if you use it on the view's provided layer.
        self.containerLayer.bounds = self.bounds
        self.layer?.addSublayer(self.containerLayer)
        
        // Constraints used for both layers
        let heightConstraint = CAConstraint(attribute: .height,
                                            relativeTo: "superlayer",
                                            attribute: .height)
        let widthConstraint = CAConstraint(attribute: .width,
                                           relativeTo: "superlayer",
                                           attribute: .width)
        
        let centerXConstraint = CAConstraint(attribute: .midX, relativeTo: "superlayer", attribute: .midX)
        let centerYConstraint = CAConstraint(attribute: .midY, relativeTo: "superlayer", attribute: .midY)
        
        // Add the base gray gradient background
        self.gradientBackgroundLayer.frame = self.frame
        self.containerLayer.addSublayer(self.gradientBackgroundLayer)
        self.gradientBackgroundLayer.constraints = [heightConstraint, widthConstraint, centerXConstraint, centerYConstraint]
        
        // Add the brushed metal along with a compositingFilter/blend mode
        self.brushedMetalTextureLayer.frame = self.frame
        self.containerLayer.addSublayer(self.brushedMetalTextureLayer)
        self.brushedMetalTextureLayer.constraints = [heightConstraint, widthConstraint, centerXConstraint, centerYConstraint]
        self.brushedMetalTextureLayer.compositingFilter = "softLightBlendMode"
        
        // Activate the constraints
        self.containerLayer.layoutManager = CAConstraintLayoutManager()
    }
    
    override func layout() {
        super.layout()
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.containerLayer.frame = self.frame
        CATransaction.commit()
    }
    
    override func viewDidChangeBackingProperties() {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.containerLayer.contentsScale = self.window?.backingScaleFactor ?? 1.0
        self.brushedMetalTextureLayer.contentsScale = self.window?.backingScaleFactor ?? 1.0
        self.gradientBackgroundLayer.contentsScale = self.window?.backingScaleFactor ?? 1.0
        self.brushedMetalTextureLayer.updateBackingProperties(contentScale: self.window?.backingScaleFactor ?? 1.0)
        self.gradientBackgroundLayer.updateBackingProperties(contentScale: self.window?.backingScaleFactor ?? 1.0)
        CATransaction.commit()
    }
}
