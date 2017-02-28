//
//  UniformData.swift
//  OpenGL test
//
//  Created by William Wold on 2/2/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit


class UniformBase {
	
	func apply(loc: GLint) {}
}

class UniformData<T>: UniformBase {
	
	var val: T
	
	init(_ val: T) {
		self.val = val
	}
	
	func set(_ val: T) {
		self.val = val
	}
}

class UniformFloat: UniformData<GLfloat> {
	override func apply(loc: GLint) {
		glUniform1f(loc, val)
	}
}

class UniformInt: UniformData<GLint> {
	override func apply(loc: GLint) {
		glUniform1i(loc, val)
	}
}

class UniformVec2: UniformData<(GLfloat, GLfloat)> {
	override func apply(loc: GLint) {
		glUniform2f(loc, val.0, val.1)
	}
}

class UniformVec3: UniformData<(GLfloat, GLfloat, GLfloat)> {
	override func apply(loc: GLint) {
		glUniform3f(loc, val.0, val.1, val.2)
	}
}

class UniformMatrix4: UniformData<GLKMatrix4> {
	
	static func getPtr(input: GLKMatrix4) -> [Float] {
		var out = [Float]();
		for i in 0..<16 {
			out.append(input[i])
		}
		return out
	}
	
	override func apply(loc: GLint) {
		glUniformMatrix4fv(loc, 1, GLboolean(GL_FALSE), UniformMatrix4.getPtr(input: val))
	}
}

class UniformTex: UniformBase {
	
	var texId: GLuint = 0
	
	override init() {
		super.init()
		glGenTextures(1, &texId)
	}
	
	deinit {
		glDeleteTextures(1, &texId)
	}
	
	override func apply(loc: GLint) {
		glActiveTexture(GLenum(GL_TEXTURE0))
		glBindTexture(GLenum(GL_TEXTURE_2D), texId)
		glUniform1i(loc, GLint(0))
	}
}




