//
//  Matrix.swift
//  MetalPlayground-iOS
//
//  Created by Aaron Sky on 4/17/20.
//

import Foundation

extension matrix_float4x4 {
    static var identity: matrix_float4x4 {
        matrix_identity_float4x4
    }
    
    var normalMatrix: matrix_float3x3 {
        let upperLeft = matrix_float3x3(SIMD3<Float>(self[0].x, self[0].y, self[0].z),
                                        SIMD3<Float>(self[1].x, self[1].y, self[1].z),
                                        SIMD3<Float>(self[2].x, self[2].y, self[2].z))
        return upperLeft.transpose.inverse
    }
    
    init(lookingAt target: SIMD3<Float>, eye: SIMD3<Float>, up: SIMD3<Float>) {
        let z = normalize(target - eye)
        let x = normalize(cross(up, z))
        let y = cross(z, x)
        let t = SIMD3<Float>(x: -dot(x, eye), y: -dot(y, eye), z: -dot(z, eye))
        
        self.init(SIMD4<Float>(x.x, y.x, z.x, 0),
                  SIMD4<Float>(x.y, y.y, y.z, 0),
                  SIMD4<Float>(x.z, y.z, z.z, 0),
                  SIMD4<Float>(t.x, t.y, t.z, 1))
    }
    
    init(perspectiveIn fovYRadians: Float, aspect: Float, nearZ: Float, farZ: Float) {       
        let yScale = 1 / tan(fovYRadians * 0.5)
        let xScale = yScale / aspect
        let quotient = farZ / (farZ - nearZ)
        
        self.init(SIMD4<Float>(xScale, 0,      0,                 0),
                  SIMD4<Float>(0,      yScale, 0,                 0),
                  SIMD4<Float>(0,      0,      quotient,          1),
                  SIMD4<Float>(0,      0,      quotient * -nearZ, 0))
    }
    
    static func translationMatrix(from vec: SIMD3<Float>) -> Self {
        self.init(SIMD4<Float>(1,     0,     0,     0),
                  SIMD4<Float>(0,     1,     0,     0),
                  SIMD4<Float>(0,     0,     1,     0),
                  SIMD4<Float>(vec.x, vec.y, vec.z, 1))
    }
    
    func translated(with vec: SIMD3<Float>) -> Self {
        matrix_float4x4.translationMatrix(from: vec) * self
    }
    
    static func rotationMatrix(by radians: Float, axis: SIMD3<Float>) -> Self {
        let axis = normalize(axis)
        let ct = cos(radians)
        let st = sin(radians)
        let ci = 1 - ct
        let (x, y, z) = axis.xyz
        
        return self.init(SIMD4<Float>(ct + x * x * ci,     y * x * ci + z * st, z * x * ci - y * st, 0),
                         SIMD4<Float>(x * y * ci - z * st, ct + y * y * ci,     z * y * ci + x * st, 0),
                         SIMD4<Float>(x * z * ci + y * st, y * z * ci - x * st, ct + z * z * ci,     0),
                         SIMD4<Float>(0,                   0,                   0,                   1))
    }
    
    func rotatedBy(_ radians: Float, axis: SIMD3<Float>) -> Self {
        matrix_float4x4.rotationMatrix(by: radians, axis: axis) * self
    }
    
    static func scaleMatrix(from vec: SIMD3<Float>) -> Self {
        self.init(SIMD4<Float>(vec.x, 0,     0,     0),
                  SIMD4<Float>(0,     vec.y, 0,     0),
                  SIMD4<Float>(0,     0,     vec.z, 0),
                  SIMD4<Float>(0,     0,     0,     1))
    }
    
    func scaled(with vec: SIMD3<Float>) -> Self {
        matrix_float4x4.scaleMatrix(from: vec) * self
    }
}
