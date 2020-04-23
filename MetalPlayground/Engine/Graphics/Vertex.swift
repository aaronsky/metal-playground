//
//  Vertex.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Metal
import MetalKit
import ModelIO

struct Vertex {
    var position: SIMD3<Float>
    var normal: SIMD3<Float>
    var tangent: SIMD3<Float>
    var textureCoordinates: SIMD2<Float>
    
    static var mtlDescriptor: MTLVertexDescriptor {
        // Create a Metal vertex descriptor that specifies how vertices are laid out for input into the render
        // pipeline and how Model I/O must condition the vertex data.
        let descriptor = MTLVertexDescriptor()
        let bufferIndex = Int(VertexBufferIndex.attributes.rawValue)
        var offset = 0
        
        // Positions.
        descriptor.attributes[Int(VertexAttribute.position.rawValue)].format = .float3
        descriptor.attributes[Int(VertexAttribute.position.rawValue)].bufferIndex = bufferIndex
        descriptor.attributes[Int(VertexAttribute.position.rawValue)].offset = offset
        
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        // Normals.
        descriptor.attributes[Int(VertexAttribute.normal.rawValue)].format = .float3
        descriptor.attributes[Int(VertexAttribute.normal.rawValue)].bufferIndex = bufferIndex
        descriptor.attributes[Int(VertexAttribute.normal.rawValue)].offset = offset
        
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        // Tangents.
        descriptor.attributes[Int(VertexAttribute.tangent.rawValue)].format = .float3
        descriptor.attributes[Int(VertexAttribute.tangent.rawValue)].bufferIndex = bufferIndex
        descriptor.attributes[Int(VertexAttribute.tangent.rawValue)].offset = offset
        
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        // Texture coordinates.
        descriptor.attributes[Int(VertexAttribute.texcoord.rawValue)].format = .float2
        descriptor.attributes[Int(VertexAttribute.texcoord.rawValue)].bufferIndex = bufferIndex
        descriptor.attributes[Int(VertexAttribute.texcoord.rawValue)].offset = offset
        
        // Position buffer layout.
        descriptor.layouts[bufferIndex].stride = MemoryLayout<Vertex>.stride
        descriptor.layouts[bufferIndex].stepRate = 1
        descriptor.layouts[bufferIndex].stepFunction = .perVertex
        
        return descriptor
    }
    
    static var modelIODescriptor: MDLVertexDescriptor {
        let descriptor = MTKModelIOVertexDescriptorFromMetal(Vertex.mtlDescriptor)
        
        let names = [
            MDLVertexAttributePosition,
            MDLVertexAttributeNormal,
            MDLVertexAttributeTangent,
            MDLVertexAttributeTextureCoordinate
        ]
        for i in 0..<names.count {
            guard let attribute = descriptor.attributes[i] as? MDLVertexAttribute else {
                continue
            }
            attribute.name = names[i]
        }
        
        return descriptor
    }
}
