//
//  Engine.swift
//  MetalEngine
//
//  Created by Aaron Sky on 4/10/20.
//

import MetalKit

public final class Engine {
    enum Error: Swift.Error {
        case noDevice
    }
    
    static var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("\(Error.noDevice)")
        }
        return device
    }()
    
    private static let colorPixelFormat: MTLPixelFormat = .bgra8Unorm_srgb
    private static let depthStencilPixelFormat: MTLPixelFormat = .depth32Float
    
    private static let maxInFlightBufferCount = 3
    private var inFlightSemaphore: DispatchSemaphore = DispatchSemaphore(value: Engine.maxInFlightBufferCount)
    
    private var gameTime = GameTime()
    
    var scenes: Scenes
    var renderer: Renderer
    
    private var viewProxy: MTKViewProxy
    #if DEBUG
    private var debugging: Debugging
    #endif
    
    public init(in view: MTKView) throws {
        view.device = Engine.device
        view.colorPixelFormat = Engine.colorPixelFormat
        view.depthStencilPixelFormat = Engine.depthStencilPixelFormat
        
        scenes = Scenes()
        scenes.current = TestScene()
        viewProxy = MTKViewProxy()
        renderer = Renderer(bufferCount: Engine.maxInFlightBufferCount)
        #if DEBUG
        debugging = Debugging()
        #endif
        
        viewProxy.delegate = self
        viewProxy.mtkView(view, drawableSizeWillChange: view.drawableSize)
        
        #if DEBUG
        debugging.delegate = self
        #endif
        
        view.delegate = viewProxy
    }
    
    func update() {
        scenes.current?.update()
    }
}

extension Engine: MTKViewProxyDelegate {
    func drawableSizeWillChange(to size: CGSize, in view: MTKView) {
        scenes.current?.drawableSizeWillChange(to: size)
    }
    
    // run loop
    func draw(in view: MTKView) {
        _ = inFlightSemaphore.wait(timeout: .distantFuture)
        update()
        renderer.draw(scenes.current, in: view) { _ in
            self.inFlightSemaphore.signal()
        }
    }
}

#if DEBUG
extension Engine: DebuggingDelegate {
    func onExit() {
        
    }
    
    func onReloadScene() {
        
    }
}
#endif
