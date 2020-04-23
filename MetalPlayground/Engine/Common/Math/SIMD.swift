//
//  SIMD.swift
//  MetalPlayground-iOS
//
//  Created by Aaron Sky on 4/17/20.
//

import Foundation

extension SIMD2 {
    var xy: (Scalar, Scalar) {
        (x, y)
    }
}

extension SIMD3 {
    var xy: (Scalar, Scalar) {
        (x, y)
    }
    
    var xz: (Scalar, Scalar) {
        (x, z)
    }
    
    var yz: (Scalar, Scalar) {
        (y, z)
    }
    
    var xyz: (Scalar, Scalar, Scalar) {
        (x, y, z)
    }
}
