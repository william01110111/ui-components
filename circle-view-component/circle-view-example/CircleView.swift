//
//  CirclePath.swift
//  bezier-path
//
//  Created by Make School on 2/6/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIControl {

    // MARK: - Private Vars
    
    private let gradLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    private let backShape = CAShapeLayer()
    private let label = UILabel()
    
    
    // MARK: - Inspectables
    
    @IBInspectable var strokeWidth: CGFloat = 10 {
        didSet {
            // 
            setNeedsLayout()
        }
    }
    
    @IBInspectable var strokeOffset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var strokeColor: UIColor = UIColor(white: 1, alpha: 0.5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var gradientColorA: UIColor = UIColor.red {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var gradientColorB: UIColor = UIColor.yellow {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    // MARK: - Public vars
    
    /** 
     Displays the value in a range of 0 to 1 as the 
     stroke of the arc. 
    */
    
    // TODO: Add starting property
    // TODO: Add start and end values for range
    
    var value: Float = 0.5 {
        didSet {
            drawPath()
        }
    }
    
    func drawPath() {
        let strokeEnd = value > 0.001 ? value : 0.001
        shapeLayer.strokeEnd = CGFloat(strokeEnd)
        let n = Int(value * 100)
        label.text = "\(n)"
    }
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    // MARK: - Class Overrides
    
    override func layoutSubviews() {
        setup()
    }
    
    private var touchX: CGFloat = 0
    private var lastValue: Float = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        touchX = location.x
        lastValue = value
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let newX = location.x
        let deltaX = (newX - touchX) * 0.01 // *** Think about this!
        print(deltaX)
        var newValue = lastValue + Float(deltaX)
        newValue = max(min(newValue, 1), 0)
        value = newValue
        
        // TODO: connect this to value update
        // TODO: Send out a few more messages
        sendActions(for: .valueChanged)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    
    
    
    // MARK: - Private methods
    
    func setup() {
        
        // Set up back shape
        layer.addSublayer(backShape)
        
        // Set up gradient
        layer.addSublayer(gradLayer)
        
        gradLayer.frame = bounds
        let colorA = gradientColorA.cgColor
        let colorB = gradientColorB.cgColor
        gradLayer.colors = [colorA, colorB]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // Set up main stroke
        layer.addSublayer(shapeLayer)
        
        let path = UIBezierPath()
        
        let cx = bounds.width / 2
        let cy = bounds.height / 2
        let c = CGPoint(x: cx, y: cy)
        var radius = cx < cy ? cx : cy
        radius -= (strokeWidth + strokeOffset) / 2
        
        let pi2 = CGFloat(M_PI * 2)
        let start = pi2 * 6 / 8
        let end = pi2 * (6 / 8) - 0.00001
        
        path.addArc(withCenter: c, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = strokeWidth + strokeOffset
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeEnd = CGFloat(value)
        shapeLayer.lineCap = "round"
        
        gradLayer.mask = shapeLayer
        
        backShape.path = path.cgPath
        backShape.fillColor = UIColor.clear.cgColor
        backShape.lineWidth = strokeWidth
        backShape.lineCap = "round"
        backShape.strokeColor = strokeColor.cgColor
        
        // Set label 
        addSubview(label)
        let insetX = bounds.width / 4
        let insetY = bounds.height / 4
        label.frame = bounds.insetBy(dx: insetX, dy: insetY)
        label.font = UIFont.systemFont(ofSize: 33)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "99"
        
        drawPath()
    }
    
    
    
}




