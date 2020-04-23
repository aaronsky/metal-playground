//
//  TorusComponent.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

struct TorusComponent: Component, RenderableComponent {
    var mesh: PrimitiveMesh
    var shader: Shader
    weak var delegate: ComponentDelegate?
    
    init(tubeRadius: Float, centerRadius: Float, subdivisions: Int) {
        mesh = PrimitiveMesh.torus(tubeRadius: tubeRadius, centerRadius: centerRadius, subdivisions: subdivisions)
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

// MARK: Pre-defined Primitives

extension PrimitiveMesh {
    static func torus(tubeRadius: Float, centerRadius: Float, subdivisions: Int) -> PrimitiveMesh {
        let x = { (theta: Float, phi: Float) in (tubeRadius * cos(theta) + centerRadius) * cos(phi) }
        let y = { (theta: Float, phi: Float) in (tubeRadius * cos(theta) + centerRadius) * sin(phi) }
        let z = { (theta: Float) in tubeRadius * sin(theta) }
        
        return PrimitiveMesh { builder in
            //Iterate over every i,j square patch on the surface
            for i in 0..<subdivisions {
                for j in 0..<subdivisions {
                    let t0 = mix(0, .twoPi, Float(i) / Float(subdivisions))
                    let t1 = mix(0, .twoPi, Float(i + 1) / Float(subdivisions))
                    let p0 = mix(0, .twoPi, Float(j) / Float(subdivisions))
                    let p1 = mix(0, .twoPi, Float(j + 1) / Float(subdivisions))
                    let u0 = mix(0, 1, Float(i) / Float(subdivisions))
                    let u1 = mix(0, 1, Float(i + 1) / Float(subdivisions))
                    let v0 = mix(0, 1, Float(j) / Float(subdivisions))
                    let v1 = mix(0, 1, Float(j + 1) / Float(subdivisions))
                    
                    builder.addSquare((position: [x(t0, p0), y(t0, p0), z(t0)], textureCoordinates: [u0, v0]),
                                      (position: [x(t1, p0), y(t1, p0), z(t1)], textureCoordinates: [u1, v0]),
                                      (position: [x(t0, p1), y(t0, p1), z(t0)], textureCoordinates: [u1, v1]),
                                      (position: [x(t1, p1), y(t1, p1), z(t1)], textureCoordinates: [u0, v1]))
                }
            }
        }
    }
    
}
