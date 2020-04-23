//
//  GameViewController.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/9/20.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
typealias PlatformSpecificViewController = UIViewController
#elseif os(macOS)
import AppKit
typealias PlatformSpecificViewController = NSViewController
#endif

import MetalKit

class MainViewController: PlatformSpecificViewController {
    var metalKitView: MTKView!
    var engine: Engine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let metalKitView = view as? MTKView else {
            fatalError("View controller not configured to hold a single MTKView")
        }
        do {
            engine = try Engine(in: metalKitView)
        } catch {
            fatalError("Error creating engine: \(error)")
        }
        
        self.metalKitView = metalKitView
    }
}

protocol MTKViewProxyDelegate: class {
    func drawableSizeWillChange(to size: CGSize, in view: MTKView)
    func draw(in view: MTKView)
}

class MTKViewProxy: NSObject, MTKViewDelegate {
    weak var delegate: MTKViewProxyDelegate?
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        delegate?.drawableSizeWillChange(to: size, in: view)
    }
    
    func draw(in view: MTKView) {
        delegate?.draw(in: view)
    }
}
