//
//  CylinderComponent.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

struct CylinderComponent: Component, RenderableComponent {
    var mesh: PrimitiveMesh
    var shader: Shader
    weak var delegate: ComponentDelegate?
    
    init(radius: Float, radialDivisions: Int, heightDivisions: Int) {
        mesh = PrimitiveMesh.cylinder(radius: radius, radialDivisions: radialDivisions, heightDivisions: heightDivisions)
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
    static func cylinder(radius: Float, radialDivisions: Int, heightDivisions: Int) -> PrimitiveMesh {
        let x = { radius * cos($0) }
        let y = { radius * sin($0) }
        return PrimitiveMesh { builder in
            for v in 0..<heightDivisions {
                for u in 0..<radialDivisions {
                    let t0 = mix(0, .twoPi, Float(u) / Float(radialDivisions))
                    let t1 = mix(0, .twoPi, Float(u + 1) / Float(radialDivisions))
                    let h0 = mix(-0.5, 0.5, Float(v) / Float(heightDivisions))
                    let h1 = mix(-0.5, 0.5, Float(v + 1) / Float(heightDivisions))
                    let u0 = mix(0, 1, Float(u) / Float(radialDivisions))
                    let u1 = mix(0, 1, Float(u + 1) / Float(radialDivisions))
                    let v0 = mix(0, 1, Float(v) / Float(heightDivisions))
                    let v1 = mix(0, 1, Float(v + 1) / Float(heightDivisions))
                    
                    builder.addSquare((position: [x(t0), y(t0), h0], textureCoordinates: [u0, v0]),
                                      (position: [x(t1), y(t1), h0], textureCoordinates: [u1, v0]),
                                      (position: [x(t0), y(t0), h1], textureCoordinates: [u1, v1]),
                                      (position: [x(t1), y(t1), h1], textureCoordinates: [u0, v1]))
                    
                }
                
            }
            for u in 0..<radialDivisions {
                let t0 = mix(0, .twoPi, Float(u) / Float(radialDivisions))
                let t1 = mix(0, .twoPi, Float(u + 1) / Float(radialDivisions))
                let u0 = mix(0, 1, Float(u) / Float(radialDivisions))
                let u1 = mix(0, 1, Float(u + 1) / Float(radialDivisions))
                
                builder.addTriangle((position: [0, 0, -0.5], textureCoordinates: [u0, u0]),
                                    (position: [x(t0), y(t0), -0.5], textureCoordinates: [u0, u1]),
                                    (position: [x(t1), y(t1), -0.5], textureCoordinates: [u1, u1]))
                builder.addTriangle((position: [0, 0, -0.5], textureCoordinates: [u0, u0]),
                                    (position: [x(t0), y(t0), -0.5], textureCoordinates: [u0, u1]),
                                    (position: [x(t1), y(t1), -0.5], textureCoordinates: [u1, u1]))
            }
        }
    }
}
