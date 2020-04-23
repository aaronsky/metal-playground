//
//  Debugging.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import Foundation

protocol DebuggingDelegate: class {
    func onExit()
    func onReloadScene()
}

class Debugging {
    weak var delegate: DebuggingDelegate?
    
    func update() {
        
    }
}
