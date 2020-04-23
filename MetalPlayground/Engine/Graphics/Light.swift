//
//  Light.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Foundation

struct Light {
    enum Kind {
        case point
        case direction
        case spotlight
    }
    
    let kind: Kind = .point
    
    let ambient: SIMD3<Float> = .init(repeating: 0.05)
    let diffuse: SIMD3<Float> = .init(repeating: 0.8)
    let specular: SIMD3<Float> = .one
    
    let constant: Float = 1.0
    let linear: Float = 0.09
    let quadratic: Float = 0.032
}
