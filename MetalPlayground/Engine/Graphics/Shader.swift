//
//  Shader.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Metal

protocol Shader {
    var label: String { get }
    var bundle: Bundle { get }
    var format: ShaderFormat { get }
    var vertexFunction: ShaderFunction { get }
    var fragmentFunction: ShaderFunction { get }
    var vertexDescriptor: MTLVertexDescriptor? { get }
}

struct ShaderFormat {
    var sampleCount: Int
    var colorPixelFormat: MTLPixelFormat
    var depthPixelFormat: MTLPixelFormat
    var stencilPixelFormat: MTLPixelFormat
}

struct ShaderFunction {
    var name: String
    var constantValues: (() -> MTLFunctionConstantValues)?
}

enum ShaderError: Swift.Error {
    case notFound
}

// MARK: Metal Extensions

extension MTLDevice {
    func makeRenderPipelineState(shader: Shader, library: MTLLibrary) throws -> MTLRenderPipelineState {
        let descriptor = try MTLRenderPipelineDescriptor(shader: shader, library: library)
        return try makeRenderPipelineState(descriptor: descriptor)
    }
    
    func makeRenderPipelineState(shader: Shader, library: MTLLibrary, completion: @escaping (MTLRenderPipelineState?, Error?) -> Void) {
        do {
            let descriptor = try MTLRenderPipelineDescriptor(shader: shader, library: library)
            makeRenderPipelineState(descriptor: descriptor, completionHandler: completion)
        } catch {
            return completion(nil, error)
        }
    }
}

extension MTLLibrary {
    func makeFunction(_ function: ShaderFunction) throws -> MTLFunction {
        if let constantValues = function.constantValues {
            return try makeFunction(name: function.name, constantValues: constantValues())
        }
        guard let function = makeFunction(name: function.name) else {
            throw ShaderError.notFound
        }
        return function
    }
    
    func makeFunction(_ function: ShaderFunction, completion: @escaping (MTLFunction?, Error?) -> Void) {
        let constantValues = function.constantValues ?? { MTLFunctionConstantValues() }
        makeFunction(name: function.name, constantValues: constantValues(), completionHandler: completion)
    }
}

extension MTLRenderPipelineDescriptor {
    convenience init(shader: Shader, library: MTLLibrary) throws {
        self.init()
        
        label = shader.label
        vertexFunction = try library.makeFunction(shader.vertexFunction)
        fragmentFunction = try library.makeFunction(shader.fragmentFunction)
        vertexDescriptor = shader.vertexDescriptor
        sampleCount = shader.format.sampleCount
        colorAttachments[0].pixelFormat = shader.format.colorPixelFormat
        depthAttachmentPixelFormat = shader.format.depthPixelFormat
        stencilAttachmentPixelFormat = shader.format.stencilPixelFormat
    }
}
