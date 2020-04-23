//
//  Bundle+MetalEngine.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/12/20.
//

import Foundation

extension Bundle {
    static var current: Bundle {
        Bundle(for: Engine.self)
    }
}
