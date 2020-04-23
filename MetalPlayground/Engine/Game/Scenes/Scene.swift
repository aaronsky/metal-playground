//
//  Scene.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Metal
import CoreGraphics

protocol Scene {
    func update()
    func drawableSizeWillChange(to size: CGSize)
    func draw(into renderEncoder: MTLRenderCommandEncoder, pipeline: Pipeline)
}

class Scenes {
    var current: Scene?
}
