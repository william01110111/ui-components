//
//  SpinnerView.swift
//  OpenGL test
//
//  Created by William Wold on 2/2/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import UIKit
import GLKit

class SpinnerView: WMGLView {
	
	let vertShaderSrc = ""
		+	"attribute vec4 pos; "
		+	"attribute vec2 uv; "
		+	"varying lowp vec2 fragUV; "
		+	"void main(void) { "
		+		"gl_Position = pos; "
		//+		"fragColor = vec4(0.5, 0.0, 1.0, 1.0); "
		+		"fragUV = uv; "
		+	"} "
	
	/*
	let fragShaderSrc = ""
	+	"varying lowp vec4 fragColor; "
	+	"varying lowp vec2 fragUV; "
	+	"void main(void) { "
	+		"gl_FragColor = fragColor; "
	+	"} "
	*/
	
	let spinnerFragShaderSrc = ""
		+	"uniform lowp float cycle; "
		+	"varying lowp vec2 fragUV; "
		+	"precision lowp float; "
		+	"void main(void) { "
		+		"float dstSq = fragUV.x*fragUV.x+fragUV.y*fragUV.y; "
		+		"if (dstSq<0.9*0.9 && dstSq>0.7*0.7) { "
		//+			"float cycle = 0.33; "
		+			"float ang = degrees(atan(fragUV.y, fragUV.x))/360.0; "
		+			"gl_FragColor.r=1.0-mod(ang-cycle*1.0+0.5, 1.0); "
		+			"gl_FragColor.g=1.0-mod(ang-cycle*2.0, 1.0); "
		+			"gl_FragColor.b=1.0-mod(ang-cycle*3.0, 1.0); "
		+			"gl_FragColor.a = 1.0; "
		+		"} "
		+		"else { "
		+			"gl_FragColor = vec4(0, 0, 0, 0); "
		+		"} "
		+	"}"
	
	let vertices : [ShapeVert] = [
		ShapeVert( 0.0,  0.25, 0.0),    // TOP
		ShapeVert(-0.5, -0.25, 0.0),    // LEFT
		ShapeVert( 0.5, -0.25, 0.0),    // RIGHT
	]
	
	fileprivate var object = Shape()
	
	var cycle = UniformFloat(0.0)
	
	override func setup() {
		
		super.setup()
		
		let shader = ShaderProgram(vertAttribs: Shape.vertexAttrs, vertShader: vertShaderSrc, fragShader: spinnerFragShaderSrc)
		
		shader.addUniform(uniform: cycle, name: "cycle")
		
		object = FullRect(shader: shader)
		
		drawables.append(object)
		
		//object = Shape(verts: vertices, indices: [0, 1, 2], shader: ShaderProgram(vert: vertShaderSrc, frag: fragShaderSrc))
	}
	
	override func update(delta: Double) {
		
		cycle.val += GLfloat(delta*0.5)
		
		cycle.val = cycle.val - floor(cycle.val)
	}
}
