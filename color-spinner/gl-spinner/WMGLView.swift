//
//  ColorSpinnerView.swift
//  Triangle
//
//  Created by William Wold on 1/30/17.
//  Copyright © 2017 BurtK. All rights reserved.
//

import UIKit
import GLKit

@IBDesignable
class WMGLView: GLKView {
	
	var lastFrameTime: Double = 0
	var displayLink: CADisplayLink!
	var drawables = [Drawable]()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	func setup() {
		
		backgroundColor = UIColor.clear
		isOpaque = false
		
		enableSetNeedsDisplay = true
		
		self.context = EAGLContext(api: .openGLES2)
		EAGLContext.setCurrent(self.context)
		
		glEnable(GLenum(GL_BLEND))
		glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
		
		//_ = Delayer(seconds: frameTime, repeats: true, callback: setNeedsDisplay)
		
		displayLink = CADisplayLink(target: self, selector: #selector(displayRefreshed))
		
		displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
		lastFrameTime = displayLink.timestamp
	}
	
	func displayRefreshed() {
		let deltaTime = displayLink.timestamp - lastFrameTime
		lastFrameTime = displayLink.timestamp
		
		update(delta: deltaTime)
		
		setNeedsDisplay()
	}
	
	func update(delta: Double) {}
	
	override func draw(_ rect: CGRect) {
		
		glClearColor(0.0, 0.0, 0.0, 0.0);
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
		
		for i in drawables {
			i.draw()
		}
	}
	
	func BUFFER_OFFSET(_ n: Int) -> UnsafeRawPointer {
		let ptr: UnsafeRawPointer? = nil
		return ptr! + n * MemoryLayout<Void>.size
	}
}

protocol Drawable {
	func draw()
}


