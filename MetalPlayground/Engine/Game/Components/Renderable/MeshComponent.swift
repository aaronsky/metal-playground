//
//  MeshComponent.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Metal

struct MeshComponent: Component, RenderableComponent {
    var mesh: ModelMesh
    var shader: Shader
    weak var delegate: ComponentDelegate?
    
    init(url: URL) throws {
        mesh = try ModelMesh(url: url)
        shader = BasicShader(vertexDescriptor: mesh.vertexDescriptor)
    }
    
    func update() {
        
    }
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        guard let renderState = try? pipeline.renderState(for: shader) else {
            return
        }
        renderEncoder.setRenderPipelineState(renderState)
        renderEncoder.draw(model: mesh)
    }
}

