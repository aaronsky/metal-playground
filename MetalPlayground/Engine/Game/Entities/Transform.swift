//
//  Transform.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Foundation

class Transform {
    private var isDirty = true
    var position: SIMD3<Float> {
        didSet {
            isDirty = true
        }
    }
    var rotation: Rotation {
        didSet {
            isDirty = true
        }
    }
    var scale: SIMD3<Float> {
        didSet {
            isDirty = true
        }
    }
    
    private var _modelMatrix: matrix_float4x4 = .identity
    var modelMatrix: matrix_float4x4 {
        if isDirty {
            _modelMatrix = matrix_float4x4
                .identity
                .scaled(with: scale)
                .rotatedBy(rotation)
                .translated(with: position)
            isDirty = false
        }
        return _modelMatrix
    }
    
    init(position: SIMD3<Float> = .zero, rotation: Rotation = Rotation(), scale: SIMD3<Float> = .one) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
    }
    
    func translate(to point: SIMD3<Float>) {
        position = point
    }
    
    func translate(by scalar: SIMD3<Float>) {
        position += scalar
    }
    
    func rotate(_ angle: Float, about axis: SIMD3<Float>) {
        rotation.angle += angle
        rotation.axis = axis
    }
    
    func scale(by scalar: SIMD3<Float>) {
        scale += scalar
    }
    
    struct Rotation {
        var angle: Float {
            didSet {
                if angle > 360 {
                    angle = 0
                }
            }
        }
        var axis: SIMD3<Float>
        
        init(angle: Float = 0, axis: SIMD3<Float> = [0, 0, 0]) {
            self.angle = angle
            self.axis = axis
        }
    }
}

private extension matrix_float4x4 {
    static func rotationMatrix(_ rotation: Transform.Rotation) -> Self {
        rotationMatrix(by: rotation.angle.degreesToRadians, axis: rotation.axis)
    }
    
    func rotatedBy(_ rotation: Transform.Rotation) -> Self {
        rotatedBy(rotation.angle.degreesToRadians, axis: rotation.axis)
    }
    
    func modelMatrix(world: matrix_float4x4) -> matrix_float4x4 {
        world
    }
}
