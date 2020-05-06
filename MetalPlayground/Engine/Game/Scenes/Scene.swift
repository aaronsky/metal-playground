//
//  Scene.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal
import CoreGraphics

class Scenes {
    var current: Scene?
}

protocol Scene {
    var camera: Camera { get }
    var entities: [Entity] { get }
    func update()
    func drawableSizeWillChange(to size: CGSize)
    func draw(into renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline)
}

extension Scene {
    func update() {
        entities.update()
    }
    
    func drawableSizeWillChange(to size: CGSize) {
        camera.width = Float(size.width)
        camera.height = Float(size.height)
    }
    
    func draw(into renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        renderEncoder.pushDebugGroup("drawing \(entities.count) entities")
        
        var uniforms = FrameUniforms(viewProjectionMatrix: camera.projectionMatrix * camera.viewMatrix,
                                     cameraPosition: camera.position,
                                     directionalLightInvDirection: [0, 1, 0],
                                     lightPosition: [0, 5, 0])
        uniforms.assignToBuffer(pipeline.activeUniformBuffer)
        
        entities.draw(renderEncoder, pipeline: pipeline)
        
        renderEncoder.popDebugGroup()
    }
}
