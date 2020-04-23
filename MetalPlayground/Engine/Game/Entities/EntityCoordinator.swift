//
//  EntityCoordinator.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

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
