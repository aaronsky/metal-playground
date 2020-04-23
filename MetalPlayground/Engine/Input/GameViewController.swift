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
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalKitView = view as? MTKView
        metalKitView.device = MTLCreateSystemDefaultDevice()
        
        assert(metalKitView.device != nil, "Metal is not supported on this device")
        
        do {
            renderer = try Renderer(with: metalKitView)
        } catch {
            fatalError("Renderer failed initialization with error: \(error)")
        }
        
        renderer.mtkView(metalKitView, drawableSizeWillChange: metalKitView.drawableSize)
        
        metalKitView.delegate = renderer
    }
}
