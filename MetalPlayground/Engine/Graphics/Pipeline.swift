//
//  Pipeline.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

class Pipeline {    
    var libraries: [Bundle: MTLLibrary] = [:]
    var renderStates: [String: MTLRenderPipelineState] = [:]
    var depthState: MTLDepthStencilState?

    private var uniformBuffers: [MTLBuffer]
    private var currentBufferIndex: Int = 0
    
    var activeUniformBuffer: MTLBuffer {
        uniformBuffers[currentBufferIndex]
    }
    
    init(bufferCount: Int, device: MTLDevice = Engine.device) {
        uniformBuffers = Pipeline.createBuffers(of: FrameUniforms.self,
                                                device: device,
                                                count: bufferCount,
                                                prefix: "PerFrameUniforms",
                                                options: [.storageModeShared])
        
        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true
        depthState = device.makeDepthStencilState(descriptor: depthDescriptor)
    }
    
    private static func createBuffers<T>(of type: T.Type, device: MTLDevice = Engine.device, count: Int, prefix: String, options: MTLResourceOptions = []) -> [MTLBuffer] {
        (0..<count).reduce(into: []) { (accumulator, index) in
            guard let buffer = device.makeBuffer(length: MemoryLayout<T>.stride, options: options) else {
                fatalError("Could not create buffer \(index)")
            }
            buffer.label = "\(prefix)\(index)"
            accumulator.append(buffer)
        }
    }
    
    func swapBuffers(_ renderEncoder: MTLRenderCommandEncoder) {
        currentBufferIndex = (currentBufferIndex + 1) % uniformBuffers.count
        
        renderEncoder.setVertexBuffer(activeUniformBuffer, offset: 0, index: .frameUniforms)
        renderEncoder.setFragmentBuffer(activeUniformBuffer, offset: 0, index: .frameUniforms)
    }
    
    func renderState(for shader: Shader, device: MTLDevice = Engine.device) throws -> MTLRenderPipelineState {
        if let state = renderStates[shader.label] {
            return state
        }
        let library: MTLLibrary
        if let cached = libraries[shader.bundle] {
            library = cached
        } else {
            library = try device.makeDefaultLibrary(bundle: shader.bundle)
            libraries[shader.bundle] = library
        }
        return try device.makeRenderPipelineState(shader: shader, library: library)
    }
}

