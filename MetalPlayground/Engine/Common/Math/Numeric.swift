//
//  Numeric.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/17/20.
//

import Foundation

extension Numeric where Self: Comparable {
    @inlinable public func lerping(within range: Range<Self>) -> Self {
        return range.lowerBound + self * (range.upperBound - range.lowerBound)
    }
    
    public mutating func lerp(within range: Range<Self>) {
        self = range.lowerBound + self * (range.upperBound - range.lowerBound)
    }
}

extension FloatingPoint {
    var degreesToRadians: Self {
        self * .pi / 180
    }
    
    var radiansToDegrees: Self {
        self * 180 / .pi
    }
    
    static var halfPi: Self {
        .pi / 2
    }
    
    static var twoPi: Self {
        .pi * 2
    }
}

func mix(_ x: Float, _ y: Float, _ a: Float) -> Float {
    x * (1.0 - a) + y * a
}
