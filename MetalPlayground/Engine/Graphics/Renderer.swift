//
//  Renderer.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import MetalKit

class Renderer: NSObject {
    var commandQueue: MTLCommandQueue?
    private var pipeline: Pipeline
    
    public init(bufferCount: Int, device: MTLDevice = Engine.device) {
        commandQueue = device.makeCommandQueue()
        pipeline = Pipeline(bufferCount: bufferCount)
        super.init()
    }
    
    func draw(_ scene: Scene?, in view: MTKView, bufferCompletion: @escaping MTLCommandBufferHandler) {
        guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
            return
        }
        
        commandBuffer.label = "MyCommand"
        defer {
            commandBuffer.commit()
        }
        commandBuffer.addCompletedHandler(bufferCompletion)
        
        guard let descriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Set the blit behavior for the command encoder
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.392, green: 0.584, blue: 0.929, alpha: 1)
        descriptor.colorAttachments[0].storeAction = .store
        
        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            return
        }
        
        encoder.label = "MyRenderEncoder"
        
        pipeline.swapBuffers(encoder)
        
        encoder.setDepthStencilState(pipeline.depthState)
        encoder.setFrontFacing(.clockwise)
        encoder.setCullMode(.back)
        encoder.setTriangleFillMode(.fill)
        
        if let scene = scene {
            encoder.pushDebugGroup("drawing scene")
            scene.draw(into: encoder, pipeline: pipeline)
            encoder.popDebugGroup()
        }
        
        encoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
    }
}
