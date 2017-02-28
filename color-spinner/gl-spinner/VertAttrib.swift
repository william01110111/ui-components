//
//  Vertex.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

/*
enum VertexAttributes : GLuint {
	case pos = 0
	case uv = 1
}
*/

class VertAttrib {
	
	var name: String
	var index: GLuint
	var type: GLenum
	var count: GLint
	var offset: UnsafeRawPointer!
	
	init(name: String, index: GLuint, type: GLenum, count: GLint, offset: Int) {
		
		self.name = name
		self.index = index
		self.type = type
		self.count = count
		self.offset = UnsafeRawPointer(bitPattern: offset)
	}
}
