//
//  Entity.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Metal

class Entity {
    var name: String
    var components: [Component]
    var transform: Transform
    
    init(name: String = "", transform: Transform = Transform(), components: [Component] = []) {
        self.name = name
        self.transform = transform
        self.components = components
        for var component in self.components {
            component.delegate = self
        }
    }
    
    func update() {
        transform.rotate(1, about: [0, 1, 0])
        
        for component in components {
            component.update()
        }
    }
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        let nameFormatted = name.isEmpty ? "\(self)" : name
        renderEncoder.pushDebugGroup("drawing entity \(nameFormatted)")
        
        let model = transform.model
        var uniforms = MeshUniforms(modelMatrix: model,
                                    normalMatrix: model.normalMatrix)
        uniforms.set(using: renderEncoder)
        
        components
            .lazy
            .compactMap { $0 as? RenderableComponent }
            .forEach { $0.draw(renderEncoder, pipeline: pipeline) }
        
        renderEncoder.popDebugGroup()
    }
}

extension Entity: ComponentDelegate {}
