//
//  TriangleComponent.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/18/20.
//

import Metal

struct TriangleComponent: Component, RenderableComponent {
    var mesh: PrimitiveMesh
    var shader: Shader
    weak var delegate: ComponentDelegate?
    
    init() {
        mesh = PrimitiveMesh { builder in
            builder.addTriangle((position: [0.5, -0.5, 0], textureCoordinates: .zero),
                                (position: [-0.5, -0.5, 0], textureCoordinates: .zero),
                                (position: [0, 0.5, 0], textureCoordinates: .zero))
        }
        shader = BasicShader(vertexDescriptor: mesh.vertexDescriptor)
    }
    
    func update() {
        
    }
    
    func draw(_ renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        guard let renderState = try? pipeline.renderState(for: shader) else {
            return
        }
        renderEncoder.setRenderPipelineState(renderState)
        renderEncoder.draw(primitive: mesh)
    }
}
