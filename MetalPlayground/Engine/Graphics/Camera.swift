//
//  Camera.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import simd
import Metal

class Camera {
    enum MoveDirection {
        case forward
        case backward
        case left
        case right
    }
    
    var position: SIMD3<Float>
    var zoom: Float
    var nearPlane: Float
    var farPlane: Float

    var width: Float = 1
    var height: Float = 1
    
    var aspectRatio: Float {
        width / height
    }
    
    var viewport: MTLViewport {
        MTLViewport(originX: Double(position.x),
                    originY: Double(position.y),
                    width: Double(width),
                    height: Double(height),
                    znear: Double(nearPlane),
                    zfar: Double(farPlane))
    }
    
    var viewMatrix: matrix_float4x4 {
        .translationMatrix(from: -position)
    }
    
    var projectionMatrix: matrix_float4x4 {
        .init(perspectiveIn: zoom.degreesToRadians, aspect: aspectRatio, nearZ: nearPlane, farZ: farPlane)
    }
    
    init(position: SIMD3<Float> = .zero, zoom: Float = 45, nearPlane: Float = 0.1, farPlane: Float = 1000) {
        self.position = position
        self.zoom = zoom
        self.nearPlane = nearPlane
        self.farPlane = farPlane
    }
    
    func update() {
        
    }
}
