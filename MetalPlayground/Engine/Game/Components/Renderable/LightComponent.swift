//
//  LightComponent.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Foundation

struct LightComponent: Component {
    var light: Light
    weak var delegate: ComponentDelegate?
    
    init() {
        light = Light()
    }
    
    func update() {
        
    }
}
