//
//  WidapFullRect.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

class FullRect: Shape {
	
	let vertices : [ShapeVert] = [
		//		Position			UV
		ShapeVert(	1.0, -1.0, 0.0,		1.0, -1.0),
		ShapeVert(	1.0,  1.0, 0.0,		1.0, 1.0),
		ShapeVert(	-1.0,  1.0, 0.0,	-1.0, 1.0),
		ShapeVert(	-1.0, -1.0, 0.0,	-1.0, -1.0)
	]
	
	let indices : [GLubyte] = [
		0, 1, 2,
		2, 3, 0
	]
	
	override init(shader: ShaderProgram) {
		
		super.init(verts: vertices, indices: indices, shader: shader)
	}
}
