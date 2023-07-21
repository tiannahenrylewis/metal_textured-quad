//
//  VertexDescriptor.swift
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-18.
//

import Foundation
import Metal
import MetalKit


extension MTLVertexDescriptor {
    
    static var customLayout: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        var offset = 0
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        offset += MemoryLayout<SIMD3<Float>>.stride
        
        //Color
//        vertexDescriptor.attributes[1].format = .float3
//        vertexDescriptor.attributes[1].bufferIndex = 0
//        vertexDescriptor.attributes[1].offset = 0
//        vertexDescriptor.layouts[1].stride = MemoryLayout<Float>.stride * 3
        
        //Texture Coordinates
        vertexDescriptor.attributes[1].format = .float2
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = offset
        offset += MemoryLayout<SIMD2<Float>>.stride
        
        vertexDescriptor.layouts[0].stride = offset
        
        return vertexDescriptor
    }
    
}


/*
 vertexDescriptor.attributes[Int(UV.rawValue)] =
     MDLVertexAttribute(name:
 MDLVertexAttributeTextureCoordinate,
                        format: .float2,
                        offset: offset,
                        bufferIndex:
 Int(BufferIndexVertices.rawValue))
 offset += MemoryLayout<float2>.stride
 */
