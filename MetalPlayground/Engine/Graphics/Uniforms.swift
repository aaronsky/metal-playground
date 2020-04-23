//
//  Uniforms.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/22/20.
//

import MetalKit

// MARK: BufferAssignable
protocol BufferAssignable {
    var vertexIndex: VertexBufferIndex? { get }
    var fragmentIndex: FragmentBufferIndex? { get }
    
    mutating func assignToBuffer(_ buffer: MTLBuffer)
    mutating func set(using renderEncoder: MTLRenderCommandEncoder)
}

extension BufferAssignable {
    var vertexIndex: VertexBufferIndex? {
        nil
    }
    
    var fragmentIndex: FragmentBufferIndex? {
        nil
    }
    
    mutating func assignToBuffer(_ buffer: MTLBuffer) {
        let address = buffer.contents()
        address.copyMemory(from: &self, byteCount: MemoryLayout.size(ofValue: self))
    }
    
    mutating func set(using renderEncoder: MTLRenderCommandEncoder) {
        if let index = vertexIndex {
            renderEncoder.setVertexBytes(&self, length: MemoryLayout.size(ofValue: self), index: index)
        }
        if let index = fragmentIndex {
            renderEncoder.setFragmentBytes(&self, length: MemoryLayout.size(ofValue: self), index: index)
        }
    }
    
}

// MARK: Uniforms Extensions

extension FrameUniforms: BufferAssignable {
    var vertexIndex: VertexBufferIndex? {
        .frameUniforms
    }
    
    var fragmentIndex: FragmentBufferIndex? {
        .frameUniforms
    }
}

extension MeshUniforms: BufferAssignable {
    var vertexIndex: VertexBufferIndex? {
        .meshUniforms
    }
}

// MARK: MTLRenderCommandEncoder Extensions

extension MTLRenderCommandEncoder {
    func setVertexBuffer(_ buffer: MTLBuffer?, offset: Int, index: VertexBufferIndex) {
        setVertexBuffer(buffer, offset: offset, index: Int(index.rawValue))
    }
    
    func setVertexBytes(_ bytes: UnsafeRawPointer, length: Int, index: VertexBufferIndex) {
        setVertexBytes(bytes, length: length, index: Int(index.rawValue))
    }
    
    func setFragmentBuffer(_ buffer: MTLBuffer?, offset: Int, index: FragmentBufferIndex) {
        setFragmentBuffer(buffer, offset: offset, index: Int(index.rawValue))
    }
    
    func setFragmentBytes(_ bytes: UnsafeRawPointer, length: Int, index: FragmentBufferIndex) {
        setFragmentBytes(bytes, length: length, index: Int(index.rawValue))
    }
    
    func setFragmentTexture(_ texture: MTLTexture?, index: TextureIndex) {
        setFragmentTexture(texture, index: Int(index.rawValue))
    }
}
