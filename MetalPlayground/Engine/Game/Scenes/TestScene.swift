//
//  TestScene.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal
import CoreGraphics

struct TestScene: Scene {
    var camera = Camera(position: [0, 2.5, 0],
                        zoom: 50,
                        nearPlane: 0.1,
                        farPlane: 1000)
    
    var entities: Entities = [
        Entity(transform: Transform(position: [0, 0, 10]),
               components: [
                try! MeshComponent(url: Bundle.current.url(forResource: "teapot", withExtension: "obj")!)
        ]),
//        Entity(transform: Transform(position: [0.0, 0.0, 10.0]),
//               components: [
//                TorusComponent(tubeRadius: 0.1, centerRadius: 0.5, subdivisions: 10)
//        ]),
//        Entity(transform: Transform(position: [2.0, 5.0, 25.0]),
//               components: [
//                SphereComponent(radius: 0.5, slices: 20, stacks: 20)
//        ]),
//        Entity(transform: Transform(position: [-1.5, -2.2, 12.5]),
//               components: [
//                CylinderComponent(radius: 0.5, radialDivisions: 10, heightDivisions: 10)
//        ]),
//        Entity(transform: Transform(position: [-3.8, -2.0, 9.3]),
//               components: [
//                ConeComponent(radius: 0.5, radialDivisions: 10, heightDivisions: 10)
//        ]),
        Entity(transform: Transform(position: [3.5, 3, 12]),
               components: [
                CubeComponent(subdivisions: 1)
        ]),
//        Entity(transform: Transform(position: [-1.7, 2.0, 8.5]),
//               components: [
//                TorusComponent(tubeRadius: 0.1, centerRadius: 0.5, subdivisions: 10)
//        ]),
//        Entity(transform: Transform(position: [1.3, -2.0, 18.5]),
//               components: [
//                SphereComponent(radius: 0.5, slices: 5, stacks: 5)
//        ]),
//        Entity(transform: Transform(position: [1.5, 2.0, 9.5]),
//               components: [
//                CylinderComponent(radius: 0.5, radialDivisions: 10, heightDivisions: 10)
//        ]),
//        Entity(transform: Transform(position: [1.5, 0.2, 14.5]),
//               components: [
//                ConeComponent(radius: 0.5, radialDivisions: 10, heightDivisions: 10)
//        ]),
//        Entity(transform: Transform(position: [-1.3, 1.0, 10.5]),
//               components: [
//                CubeComponent(subdivisions: 20)
//        ]),
    ]
    
    func update() {
        entities.update()
    }
    
    func drawableSizeWillChange(to size: CGSize) {
        camera.width = Float(size.width)
        camera.height = Float(size.height)
    }
    
    func draw(into renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline) {
        renderEncoder.pushDebugGroup("drawing \(entities.count) entities")
        
        var uniforms = FrameUniforms(viewProjectionMatrix: camera.projectionMatrix * camera.viewMatrix,
                                cameraPosition: camera.position,
                                directionalLightInvDirection: [0, 1, 0],
                                lightPosition: [0, 5, 0])
        uniforms.assignToBuffer(pipeline.activeUniformBuffer)
        
        entities.draw(renderEncoder, pipeline: pipeline)
        
        renderEncoder.popDebugGroup()
    }
}
