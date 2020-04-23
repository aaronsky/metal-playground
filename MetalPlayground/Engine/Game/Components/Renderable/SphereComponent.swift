//
//  SphereComponent.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

struct SphereComponent: Component, RenderableComponent {
    var mesh: PrimitiveMesh
    var shader: Shader
    weak var delegate: ComponentDelegate?
    
    init(radius: Float, slices: Int, stacks: Int) {
        mesh = PrimitiveMesh.sphere(radius: radius, slices: slices, stacks: stacks)
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
    static func sphere(radius: Float, slices: Int, stacks: Int) -> PrimitiveMesh {
        let x = { radius * cos($0) * cos($1) }
        let y = { radius * cos($1) * sin($0) }
        let z = { radius * sin($0) }
        
        return PrimitiveMesh { builder in
            for i in 0..<slices {
                for j in 0..<stacks {
                    let t0 = mix(0.0, .twoPi, Float(i) / Float(slices))
                    let t1 = mix(0.0, .twoPi, Float(i + 1) / Float(slices))
                    let p0 = mix(-.halfPi, .halfPi, Float(j) / Float(stacks))
                    let p1 = mix(-.halfPi, .halfPi, Float(j + 1) / Float(stacks))
                    let u0 = mix(0.0, 1.0, Float(i) / Float(slices))
                    let u1 = mix(0.0, 1.0, Float(i + 1) / Float(slices))
                    let v0 = mix(0.0, 1.0, Float(j) / Float(stacks))
                    let v1 = mix(0.0, 1.0, Float(j + 1) / Float(stacks))
                    
                    builder.addSquare((position: [x(t0, p0), y(t0, p0), z(p0)], textureCoordinates: [u0, v0]),
                                      (position: [x(t1, p0), y(t1, p0), z(p0)], textureCoordinates: [u1, v0]),
                                      (position: [x(t0, p1), y(t0, p1), z(p1)], textureCoordinates: [u1, v1]),
                                      (position: [x(t1, p1), y(t1, p1), z(p1)], textureCoordinates: [u0, v1]))
                }
            }
        }
    }
}
