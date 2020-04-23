//
//  Component.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Foundation
import Metal

protocol Component {
    var delegate: ComponentDelegate? { get set }
    func update()
}

protocol ComponentDelegate: class {
    var transform: Transform { get }
}

protocol RenderableComponent {
    func draw(_ renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline)
}
