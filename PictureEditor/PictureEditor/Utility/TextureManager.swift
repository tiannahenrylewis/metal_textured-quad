//
//  TextureManager.swift
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-19.
//

import Foundation
import MetalKit

enum TextureManager {
    static var textures: [String : MTLTexture] = [:]
    
    static func loadTextureFromFile(named fileName: String) throws -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        
        let loaderOptions: [MTKTextureLoader.Option: Any] = [
            .SRGB : false,
            .origin : MTKTextureLoader.Origin.bottomLeft,
            .textureUsage : MTLTextureUsage.shaderRead.rawValue,
            .textureStorageMode : MTLStorageMode.private.rawValue
        ]
        
        let fileExtension = URL(filePath: fileName).pathExtension.isEmpty ? "png" : nil
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Failed to Load Texture = \(fileName)")
            return nil
        }
        
        do {
            let texture = try textureLoader.newTexture(URL: url, options: loaderOptions)
            
            print("Texture Loaded: \(url.lastPathComponent)")
            return texture
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func texture(from fileName: String) -> MTLTexture? {
        if let texture = textures[fileName] {
            return texture
        }
        
        let texture = try? loadTextureFromFile(named: fileName)
        
        if texture != nil {
            textures[fileName] = texture
        }
        
        return texture
    }
}
