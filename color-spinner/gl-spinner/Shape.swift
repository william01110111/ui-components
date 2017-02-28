//
//  Shape.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

struct ShapeVert {
	var x : GLfloat = 0.0
	var y : GLfloat = 0.0
	var z : GLfloat = 0.0
	
	var u : GLfloat = 0.0
	var v : GLfloat = 0.0
	
	init(_ x : GLfloat, _ y : GLfloat, _ z : GLfloat, _ u : GLfloat = 0.0, _ v : GLfloat = 0.0) {
		self.x = x
		self.y = y
		self.z = z
		
		self.u = u
		self.v = v
	}
}

class Shape: Drawable {
	
	static let vertexAttrs: [VertAttrib] = [
		VertAttrib(name: "pos", index: 0, type: GLenum(GL_FLOAT), count: 3, offset: 0),
		VertAttrib(name: "uv", index: 1, type: GLenum(GL_FLOAT), count: 2, offset: 3 * MemoryLayout<GLfloat>.size)
	]
	
	var vertexBuffer : GLuint = 0
	var indexBuffer: GLuint = 0
	var indexCount = 0
	var shader = ShaderProgram()
	//var transform = GLKMatrix4()
	
	var x: Double = 0			{didSet {transformNeedsUpdate = true}}
	var y: Double = 0			{didSet {transformNeedsUpdate = true}}
	var rotation: Double = 0	{didSet {transformNeedsUpdate = true}}
	var scale: Double = 1		{didSet {transformNeedsUpdate = true}}
	var transformNeedsUpdate = true
	
	init() {}
	
	deinit {
		destroy()
	}
	
	init(verts: [ShapeVert], indices: [GLubyte], shader: ShaderProgram) {
		
		setVerts(verts: verts, indices: indices)
		
		self.shader = shader
	}
	
	init(shader: ShaderProgram) {
		
		self.shader = shader
	}
	
	func setVerts(verts: [ShapeVert], indices: [GLubyte]) {
		
		deleteVerts()
		
		glGenBuffers(GLsizei(1), &vertexBuffer)
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		let count = verts.count
		let size = MemoryLayout<ShapeVert>.size
		glBufferData(GLenum(GL_ARRAY_BUFFER), count * size, verts, GLenum(GL_STATIC_DRAW))
		
		glGenBuffers(GLsizei(1), &indexBuffer)
		
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
		glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indices.count * MemoryLayout<GLubyte>.size, indices, GLenum(GL_STATIC_DRAW))
		indexCount = indices.count
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
	}
	
	func updateTransform() {
		//transform = GLKMatrix4Identity
		//transform = GLKMatrix4Scale(transform, Float(scale), Float(scale), Float(scale))
		//transform = GLKMatrix4RotateZ(transform, GLKMathDegreesToRadians(Float(rotation)))
		//transform = GLKMatrix4Translate(transform, Float(x), Float(y), 0)
	}
	
	func draw() {
		
		if (transformNeedsUpdate) {
			updateTransform()
			transformNeedsUpdate = false
		}
		
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
		shader.engage()
		
		glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indexCount), GLenum(GL_UNSIGNED_BYTE), nil)
		
		shader.disengage()
		glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
	}
	
	func deleteVerts() {
		if vertexBuffer > 0 {
			glDeleteBuffers(GLsizei(1), &vertexBuffer)
			vertexBuffer = 0
		}
		
		if indexBuffer > 0 {
			glDeleteBuffers(GLsizei(1), &indexBuffer)
			indexBuffer = 0
		}
		
		indexCount = 0
	}
	
	func destroy() {
		
		deleteVerts()
		
		shader.destroy()
	}
}
