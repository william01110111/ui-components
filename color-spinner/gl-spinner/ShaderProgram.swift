//
//  ShaderProgram.swift
//  OpenGL test
//
//  Created by William Wold on 1/31/17.
//  Copyright © 2017 William Wold. All rights reserved.
//

import Foundation
import GLKit

class ShaderProgram {
	
	var programHandle : GLuint = 0
	var vertAttribs = [VertAttrib]()
	var uniforms = [UniformBase?]()
	
	init() {}
	
	deinit {
		destroy()
	}
	
	init(vertAttribs: [VertAttrib], vertShader: String, fragShader: String) {
		let vertexShaderName = self.compileShader(src: vertShader, type: GLenum(GL_VERTEX_SHADER))
		let fragmentShaderName = self.compileShader(src: fragShader, type: GLenum(GL_FRAGMENT_SHADER))
		
		self.vertAttribs = vertAttribs
		
		self.programHandle = glCreateProgram()
		glAttachShader(self.programHandle, vertexShaderName)
		glAttachShader(self.programHandle, fragmentShaderName)
		
		for i in vertAttribs {
			glBindAttribLocation(self.programHandle, i.index, i.name)
		}
		
		glLinkProgram(self.programHandle)
		
		glDeleteShader(vertexShaderName)
		glDeleteShader(fragmentShaderName)
		
		var linkStatus : GLint = 0
		glGetProgramiv(self.programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
		if linkStatus == GL_FALSE {
			var infoLength : GLsizei = 0
			let bufferLength : GLsizei = 1024
			glGetProgramiv(self.programHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
			
			let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
			var actualLength : GLsizei = 0
			
			glGetProgramInfoLog(self.programHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
			NSLog(String(validatingUTF8: info)!)
			exit(1)
		}
	}
	
	func compileShader(src shaderSrc: String, type shaderType: GLenum) -> GLuint {
		
		//let shaderString = try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue)
		let shaderString: NSString = shaderSrc as NSString
		let shaderHandle = glCreateShader(shaderType)
		var shaderStringLength : GLint = GLint(Int32(shaderString.length))
		var shaderCString = shaderString.utf8String
		glShaderSource(
			shaderHandle,
			GLsizei(1),
			&shaderCString,
			&shaderStringLength)
		
		glCompileShader(shaderHandle)
		var compileStatus : GLint = 0
		glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileStatus)
		
		if compileStatus == GL_FALSE {
			var infoLength : GLsizei = 0
			let bufferLength : GLsizei = 1024
			glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
			
			let info : [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
			var actualLength : GLsizei = 0
			
			glGetShaderInfoLog(shaderHandle, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
			NSLog(String(validatingUTF8: info)!)
			exit(1)
		}
		
		return shaderHandle
	}
	
	func addUniform(uniform: UniformBase, name: String) {
		
		let loc = glGetUniformLocation(programHandle, name)
		
		if loc < 0 {
			print("could not file uniform '"+name+"' in shader")
			return
		}
		
		//print("uniform '"+name+"' inserted at position \(loc)")
		
		while uniforms.count <= Int(loc) {
			uniforms.append(nil)
		}
		
		uniforms[Int(loc)] = uniform
	}
	
	func engage() {
		
		glUseProgram(programHandle)
		
		var i=0; while i < uniforms.count {
			uniforms[i]?.apply(loc: GLint(i))
			i+=1
		}
		
		for i in vertAttribs {
			glVertexAttribPointer(i.index, i.count, i.type, GLboolean(GL_FALSE), GLsizei(MemoryLayout<ShapeVert>.size), i.offset)
			glEnableVertexAttribArray(i.index)
		}
	}
	
	func disengage() {
		
		for i in vertAttribs {
			glDisableVertexAttribArray(i.index)
		}
		
		glUseProgram(0)
	}
	
	func destroy() {
		
		if programHandle > 0 {
			glDeleteProgram(programHandle)
			programHandle = 0
		}
	}
}
