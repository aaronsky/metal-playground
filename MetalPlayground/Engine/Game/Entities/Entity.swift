//
//  Entity.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Metal

class Entity {
    var name: String
    var transform: Transform
    var components: [Component]

    weak var parent: Entity?
    var children: [Entity] = []
    
    var modelMatrix: matrix_float4x4 {
        if let parent = parent {
            return parent.modelMatrix * transform.modelMatrix
        }
        return transform.modelMatrix
    }
    
    
    init(name: String,
         transform: Transform = Transform(),
         components: [Component] = []) {
        self.name = name
        self.transform = transform
        self.components = components
        for var component in self.components {
            component.delegate = self
        }
    }
}
 
extension Entity: ComponentDelegate {
    func update() {
        transform.rotate(1, about: [0, 1, 0])
        
        for component in components {
            component.update()
        }
        
        children.update()
    }
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        renderEncoder.pushDebugGroup("Entity – \(name)")
        
        let world = modelMatrix
        var uniforms = MeshUniforms(modelMatrix: world,
                                    normalMatrix: world.normalMatrix)
        uniforms.set(using: renderEncoder)
        
        components
            .lazy
            .compactMap { $0 as? RenderableComponent }
            .forEach { $0.draw(renderEncoder, pipeline: pipeline) }
        
        children.draw(renderEncoder, pipeline: pipeline)
        
        renderEncoder.popDebugGroup()
    }
}

typealias Entities = [Entity]

extension Entities {
    func update() {
        for entity in self {
            entity.update()
        }
    }
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        for entity in self {
            entity.draw(renderEncoder, pipeline: pipeline)
        }
    }
}
