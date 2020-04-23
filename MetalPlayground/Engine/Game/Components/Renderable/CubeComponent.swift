//
//  CubeComponent.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

struct CubeComponent: Component, RenderableComponent {
    var mesh: PrimitiveMesh
    var shader: Shader
    weak var delegate: ComponentDelegate?
    
    init(subdivisions: Int) {
        mesh = PrimitiveMesh.cube(subdivisions: subdivisions)
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
    static func cube(subdivisions: Int) -> PrimitiveMesh {
        PrimitiveMesh { builder in
            for i in 0..<subdivisions {
                for j in 0..<subdivisions {
                    //x0 and x1 are theta min and theta max
                    //y0 and y1 are phi min and phi max
                    let x0 = mix(-0.5, 0.5, Float(i) / Float(subdivisions))
                    let x1 = mix(-0.5, 0.5, Float(i + 1) / Float(subdivisions))
                    let y0 = mix(-0.5, 0.5, Float(j) / Float(subdivisions))
                    let y1 = mix(-0.5, 0.5, Float(j + 1) / Float(subdivisions))
                    let u0 = mix(0.0, 1.0, Float(i) / Float(subdivisions))
                    let u1 = mix(0.0, 1.0, Float(i + 1) / Float(subdivisions))
                    let v0 = mix(0.0, 1.0, Float(j) / Float(subdivisions))
                    let v1 = mix(0.0, 1.0, Float(j + 1) / Float(subdivisions))
                    
                    //z is 0.5 for the front of the cube
                    let z: Float = 0.5
                    
                    //front
                    builder.addSquare((position: [x0, y0, z], textureCoordinates: [u0, v0]),
                                      (position: [x1, y0, z], textureCoordinates: [u1, v0]),
                                      (position: [x0, y1, z], textureCoordinates: [u1, v1]),
                                      (position: [x1, y1, z], textureCoordinates: [u0, v1]))
                    //back
                    // -x/y/-z
                    builder.addSquare((position: [-x0, y0, -z], textureCoordinates: [u0, v0]),
                                      (position: [-x1, y0, -z], textureCoordinates: [u1, v0]),
                                      (position: [-x0, y1, -z], textureCoordinates: [u1, v1]),
                                      (position: [-x1, y1, -z], textureCoordinates: [u0, v1]))
                    //top
                    // x/-z/y
                    builder.addSquare((position: [x0, -z, y0], textureCoordinates: [u0, v0]),
                                      (position: [x1, -z, y0], textureCoordinates: [u1, v0]),
                                      (position: [x0, -z, y1], textureCoordinates: [u1, v1]),
                                      (position: [x1, -z, y1], textureCoordinates: [u0, v1]))
                    //bottom
                    // -x/z/y
                    builder.addSquare((position: [-x0, z, y0], textureCoordinates: [u0, v0]),
                                      (position: [-x1, z, y0], textureCoordinates: [u1, v0]),
                                      (position: [-x0, z, y1], textureCoordinates: [u1, v1]),
                                      (position: [-x1, z, y1], textureCoordinates: [u0, v1]))
                    //right
                    // -z/y/x
                    builder.addSquare((position: [-z, y0, x0], textureCoordinates: [u0, v0]),
                                      (position: [-z, y0, x1], textureCoordinates: [u1, v0]),
                                      (position: [-z, y1, x0], textureCoordinates: [u1, v1]),
                                      (position: [-z, y1, x1], textureCoordinates: [u0, v1]))
                    //left
                    // z/y/-x
                    builder.addSquare((position: [z, y0, -x0], textureCoordinates: [u0, v0]),
                                      (position: [z, y0, -x1], textureCoordinates: [u1, v0]),
                                      (position: [z, y1, -x0], textureCoordinates: [u1, v1]),
                                      (position: [z, y1, -x1], textureCoordinates: [u0, v1]))
                }
            }
        }
    }
}

