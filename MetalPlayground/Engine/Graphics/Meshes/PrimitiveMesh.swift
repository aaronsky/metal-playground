//
//  PrimitiveMesh.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal

struct PrimitiveMesh {
    var vertexBuffer: MTLBuffer
    var indexBuffer: MTLBuffer
    var material: Material
    
    var vertexDescriptor: MTLVertexDescriptor? {
        Vertex.mtlDescriptor
    }
    
    init(_ builder: Builder, device: MTLDevice = Engine.device) {
        let vertices = builder.container
        let indices = builder.indices.isEmpty ? vertices.indices.map(UInt16.init) : builder.indices
        let vertexDataSize = MemoryLayout<Vertex>.stride * vertices.count
        let indexDataSize = MemoryLayout<UInt16>.stride * indices.count
        
        guard
            let vertexBuffer = device.makeBuffer(length: vertexDataSize, options: .storageModeShared),
            let indexBuffer = device.makeBuffer(length: indexDataSize, options: .storageModeShared) else {
                fatalError("could not create vertex buffer")
        }
        
        let vertexContents = vertexBuffer.contents()
        vertexContents.copyMemory(from: vertices, byteCount: vertexDataSize)
        self.vertexBuffer = vertexBuffer

        let indexContents = indexBuffer.contents()
        indexContents.copyMemory(from: indices, byteCount: indexDataSize)
        self.indexBuffer = indexBuffer
        
        self.material = Material()
    }
    
    init(handler: (inout Builder) -> Void) {
        var builder = Builder()
        handler(&builder)
        self.init(builder)
    }
    
    struct Builder {
        typealias Point = (position: SIMD3<Float>, textureCoordinates: SIMD2<Float>)
        var container: [Vertex] = []
        var indices: [UInt16] = []
        
        init() {
            
        }
        
        mutating func addTriangle(_ point0: Point, _ point1: Point, _ point2: Point) {            
            let calculatedNormal = normalize(cross(point1.position - point0.position, point2.position - point1.position))
            
            container.append(Vertex(position: point0.position, normal: calculatedNormal, tangent: .zero, textureCoordinates: point0.textureCoordinates))
            container.append(Vertex(position: point1.position, normal: calculatedNormal, tangent: .zero, textureCoordinates: point1.textureCoordinates))
            container.append(Vertex(position: point2.position, normal: calculatedNormal, tangent: .zero, textureCoordinates: point2.textureCoordinates))
        }
        
        mutating func addSquare(_ point0: Point, _ point1: Point, _ point2: Point, _ point3: Point) {
            addTriangle(point0, point1, point2)
            addTriangle(point3, point2, point1)
        }
    }
}

// MARK: MTLRenderCommandEncoder

extension MTLRenderCommandEncoder {
    func draw(primitive mesh: PrimitiveMesh) {
        setVertexBuffer(mesh.vertexBuffer,
                        offset: 0,
                        index: .attributes)
        mesh.material.bind(to: self)
        
        drawIndexedPrimitives(type: .triangle,
                              indexCount: mesh.indexBuffer.length / MemoryLayout<UInt16>.stride,
                              indexType: .uint16,
                              indexBuffer: mesh.indexBuffer,
                              indexBufferOffset: 0)
        
    }
}
