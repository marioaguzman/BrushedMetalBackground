//
//  BrushedMetalTextureLayer.swift
//  BrushedMetalBackground
//
//  Created by Mario Guzman on 5/30/24.
//

import Cocoa

final class BrushedMetalTextureLayer: CALayer {
    
    private var tiledBrushedTexterLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    private let lightOverlayLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = NSColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.82).cgColor
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
        self.addSublayer(self.tiledBrushedTexterLayer)
        self.addSublayer(self.lightOverlayLayer)
    }
    
    override func layoutSublayers() {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        self.tiledBrushedTexterLayer.frame = self.bounds
        self.lightOverlayLayer.frame = self.bounds
        CATransaction.commit()
    }
    
    func updateBackingProperties(contentScale: CGFloat) {
        self.tiledBrushedTexterLayer.contentsScale = contentScale
        self.lightOverlayLayer.contentsScale = contentScale
        
        // In Core Animation, it seems to always draw the @2x image from the
        // asset catalog item. Manually going through the representations to
        // pull out the correct image size/version myself.
        let imagePattern = NSImage(named: "brushed_metal_texture")!
        let firstRep = imagePattern.representations.first { rep in
            if  contentScale >= 2.0 {
                return rep.pixelsWide == 256
            } else {
                return rep.pixelsWide == 128
            }
        }
        if  let firstRep,
            let imageRep = firstRep.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let textureTileImage = NSImage(cgImage: imageRep, size: firstRep.size)
            self.tiledBrushedTexterLayer.backgroundColor = NSColor(patternImage: textureTileImage).cgColor
        }
    }
}
