//
//  ModelMesh.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import MetalKit
import ModelIO

struct ModelMesh {
    struct Node {
        var mesh: MTKMesh
        var materials: [Material]
    }
    var nodes: [Node]
    
    var vertexDescriptor: MTLVertexDescriptor? {
        Vertex.mtlDescriptor
    }
    
    init(url: URL, device: MTLDevice = Engine.device) throws {
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: url, vertexDescriptor: Vertex.modelIODescriptor, bufferAllocator: bufferAllocator)
        
        let textureLoader = MTKTextureLoader(device: device)
        let (modelIOMeshes, metalKitMeshes) = try MTKMesh.newMeshes(asset: asset, device: device)
        nodes = zip(modelIOMeshes, metalKitMeshes).reduce(into: []) { (acc, meshes) in
            let (mdlMesh, mtkMesh) = meshes
            let materials = mdlMesh
                .submeshes?
                .lazy
                .compactMap { $0 as? MDLSubmesh }
                .map { Material(modelIOMaterial: $0.material, textureLoader: textureLoader) } ?? []
            acc.append(Node(mesh: mtkMesh, materials: materials))
        }
    }
}

// MARK: MTLRenderCommandEncoder

extension MTLRenderCommandEncoder {
    func draw(model: ModelMesh) {
        for node in model.nodes {
            let mesh = node.mesh
            let materials = node.materials
            for (i, vertexBuffer) in mesh.vertexBuffers.enumerated() {
                setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, index: i)
            }
            for (i, submesh) in mesh.submeshes.enumerated() {
                materials[i].bind(to: self)
                drawIndexedPrimitives(type: submesh.primitiveType,
                                      indexCount: submesh.indexCount,
                                      indexType: submesh.indexType,
                                      indexBuffer: submesh.indexBuffer.buffer,
                                      indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }
}
