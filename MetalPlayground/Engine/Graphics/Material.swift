//
//  Material.swift
//  MetalPlayground
//
//  Created by Aaron Sky on 4/22/20.
//

import MetalKit
import ModelIO

struct Material {
    private static var defaultTextureProperties: (MTLRegion, MTLTextureDescriptor) = {
        let bounds = MTLRegionMake2D(0, 0, 1, 1)
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm_srgb,
                                                                  width: bounds.size.width,
                                                                  height: bounds.size.height,
                                                                  mipmapped: false)
        descriptor.usage = .shaderRead
        return (bounds, descriptor)
    }()

    static var defaultTexture: MTLTexture = { device in
        let (bounds, descriptor) = Material.defaultTextureProperties
        guard let texture = device.makeTexture(descriptor: descriptor) else {
            fatalError("could not instantiate default texture")
        }
        let color: [UInt8] = [255, 255, 255, 255]
        texture.replace(region: bounds, mipmapLevel: 0, withBytes: color, bytesPerRow: 4)
        return texture
    }(Engine.device)
    
    static var defaultNormalMap: MTLTexture = { device in
        let (bounds, descriptor) = Material.defaultTextureProperties
        guard let normalMap = device.makeTexture(descriptor: descriptor) else {
            fatalError("could not instantiate default normal map")
        }
        let color: [UInt8] = [127, 127, 255, 255]
        normalMap.replace(region: bounds, mipmapLevel: 0, withBytes: color, bytesPerRow: 4)
        return normalMap
    }(Engine.device)
    
    var baseColor: MTLTexture
    var metallic: MTLTexture
    var roughness: MTLTexture
    var normal: MTLTexture
    var emissive: MTLTexture
    
    init() {
        baseColor = Material.defaultTexture
        metallic = Material.defaultTexture
        roughness = Material.defaultTexture
        normal = Material.defaultNormalMap
        emissive = Material.defaultTexture
    }
    
    init(modelIOMaterial material: MDLMaterial?, textureLoader: MTKTextureLoader) {
        baseColor = Material.texture(for: .baseColor, in: material, textureLoader: textureLoader) ?? Material.defaultTexture
        metallic = Material.texture(for: .metallic, in: material, textureLoader: textureLoader) ?? Material.defaultTexture
        roughness = Material.texture(for: .roughness, in: material, textureLoader: textureLoader) ?? Material.defaultTexture
        normal = Material.texture(for: .tangentSpaceNormal, in: material, textureLoader: textureLoader) ?? Material.defaultNormalMap
        emissive = Material.texture(for: .emission, in: material, textureLoader: textureLoader) ?? Material.defaultTexture
    }
    
    private static func texture(for semantic: MDLMaterialSemantic, in material: MDLMaterial?, textureLoader: MTKTextureLoader) -> MTLTexture? {
        guard let materialProperty = material?.property(with: semantic),
            let sourceTexture = materialProperty.textureSamplerValue?.texture else {
                return nil
        }
        return try? textureLoader.newTexture(texture: sourceTexture, options: [
            .generateMipmaps: (materialProperty.semantic != .tangentSpaceNormal)
        ])
    }
    
    func bind(to renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setFragmentTexture(baseColor, index: .baseColor)
        renderEncoder.setFragmentTexture(metallic, index: .metallic)
        renderEncoder.setFragmentTexture(roughness, index: .roughness)
        renderEncoder.setFragmentTexture(normal, index: .normal)
        renderEncoder.setFragmentTexture(emissive, index: .emissive)
    }
}
