//
//  BasicShader.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Metal

struct BasicShader: Shader {
    let label = "Basic Shader"
    let bundle = Bundle.current
    let format = ShaderFormat(sampleCount: 1,
                              colorPixelFormat: .bgra8Unorm_srgb,
                              depthPixelFormat: .depth32Float,
                              stencilPixelFormat: .invalid)
    let vertexFunction = ShaderFunction(name: "basicVertex")
    let fragmentFunction = ShaderFunction(name: "basicFragment")
    
    var vertexDescriptor: MTLVertexDescriptor?
}
