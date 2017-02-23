//
//  LoadingAnimation.swift
//  UI Component
//
//  Created by Chandan Brown on 2/10/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//

import UIKit
class LineScalePulseOut: AnimationDelegate {
    
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        
//      Colors for lines
//      let blueColor     = UIColor(r: 110, g: 148, b: 208)
//      let defaultColor  = UIColor(r: 254, g: 209, b: 67)
//      let redColor      = UIColor(r: 228, g: 36, b: 18)
//      let darkColor     = UIColor(r: 38, g: 17, b: 5)
//      let whiteColor    = UIColor.white
//      let colorArray    = [blueColor, defaultColor, redColor, darkColor, whiteColor]
        
        let lineSize = size.width / 42
        let x = (layer.bounds.size.width  - size.width) / 18
        let y = (layer.bounds.size.height - size.height) / 18
        let duration: CFTimeInterval = 1
        let beginTime  = CACurrentMediaTime()
        let beginTimes = [0.4,1.2, 1.0, 0.8, 0.6, 0.4, 0.6, 0.8, 1.0, 1.2,0.4, 0.4,1.2, 1.0, 0.8, 0.6, 0.4, 0.6, 0.8, 1.0, 1.2,0.4]
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.85, 0.25, 0.37, 0.85)
        
        // Animation
        let animation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        
        animation.repeatCount = HUGE
        animation.duration    = duration
        animation.values      = [1, 0.4, 1]
        animation.keyTimes    = [0, 0.5, 1]
        animation.isRemovedOnCompletion = false
        animation.timingFunctions = [timingFunction, timingFunction]
        
        // Draw lines
        for i in 0 ..< 22 {            

            let line = ActivityShape.line.layerWith(CGSize(width: lineSize, height: size.height), color: color)
            
            let frame = CGRect(x: x + lineSize * 2 * CGFloat(i),
                               y: y,
                               width: lineSize,
                               height: size.height)
            
            animation.beginTime = beginTime + beginTimes[i]
            line.frame = frame
            line.add(animation, forKey: "animation")
            layer.addSublayer(line)
        }
    }
}

