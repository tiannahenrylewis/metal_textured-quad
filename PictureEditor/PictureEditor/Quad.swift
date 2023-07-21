//
//  Quad.swift
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-18.
//

import Foundation
import MetalKit

struct Quad {
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let textureBuffer: MTLBuffer
    
    var vertices: [Float] = [
        -1, 1, 0, 0, 1,
        1, 1, 0, 1, 1,
        -1, -1, 0, 0, 0,
         1, -1, 0, 1, 0
    ]
    
    var indices: [UInt16] = [
        0, 3, 2,
        0, 1, 3
    ]
    
    var textureCoordinates: [simd_float2] = [
        [0.0, 1.0],
        [1.0, 1.0],
        [0.0, 0.0],
        [1.0, 0.0]
    ]
    
    init(device: MTLDevice, scale: Float = 1.0) {
        
        vertices = vertices.map( {$0 * scale} )
        
        guard let vertexBuffer = device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<Float>.stride * vertices.count,
            options: []) else {
            fatalError("🛑 Quad Vertex Buffer Failed")
        }
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count,
            options: []) else {
            fatalError("🛑 Quad Index Buffer Failed")
        }
        
        guard let textureBuffer = device.makeBuffer(
            bytes: &textureCoordinates,
            length: MemoryLayout<SIMD2<Float>>.stride * textureCoordinates.count,
            options: []) else {
            fatalError("🛑 Texture Buffer Failed")
        }
        
        self.vertexBuffer = vertexBuffer
        self.indexBuffer = indexBuffer
        self.textureBuffer = textureBuffer
    }
}
