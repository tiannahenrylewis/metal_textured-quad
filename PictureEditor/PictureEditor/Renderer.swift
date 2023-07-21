//
//  Renderer.swift
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-17.
//

import Foundation
import Metal
import MetalKit

class Renderer: NSObject, ObservableObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    static var samplerState: MTLSamplerState!
    
    static var textureDescriptor: MTLTextureDescriptor!
    var texture: MTLTexture? = nil
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState:  MTLDepthStencilState!
    
    lazy var quad: Quad = {
        Quad(device: Renderer.device, scale: 0.75)
    }()
    
    init(metalView: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Device Setup Failed")
        }
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("CommandQueue Setup Failed")
        }
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Library Setup Failed")
        }
    
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        Renderer.library = library
        
        metalView.device = device
        
        //Texture Setup
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.pixelFormat = metalView.colorPixelFormat
        textureDescriptor.usage = MTLTextureUsage.shaderRead
        textureDescriptor.storageMode = MTLStorageMode.private
        
        //Sampler Setup
        let sampler = MTLSamplerDescriptor()
        //sampler.minFilter = .nearest
        //sampler.magFilter = .linear
        //sampler.sAddressMode = .repeat
        //sampler.tAddressMode = .repeat
        Renderer.samplerState = device.makeSamplerState(descriptor: sampler)
        
        
        if let loadedTexture = TextureManager.texture(from: "Metal_Logo") {
            print("🟠 Loaded Texture: \(loadedTexture.height) - \(loadedTexture.width)")
            texture = loadedTexture
            
            textureDescriptor.width = loadedTexture.width
            textureDescriptor.height = loadedTexture.height
            Renderer.textureDescriptor = textureDescriptor
        } else {
            fatalError("🛑 Failed to Load Image Texture")
        }
        //End of Texture Setup
        
        let vertexFunction = library.makeFunction(name: "vertex_main")
        let fragmentFunction = library.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        
        do {
            //Set Custom Vertex Descriptor
            pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.customLayout
            
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError("Pipeline Setup Failed - \(error.localizedDescription)")
        }
        
        super.init()
        
        metalView.clearColor = MTLClearColorMake(0, 0, 0, 1.0)
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.delegate = self
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //print("Draw Size Updated: \(size)")
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        guard let commandBuffer = Renderer.commandQueue.makeCommandBuffer() else {
            fatalError("CommandBuffer Setup Failed")
        }
        
        guard let renderDescriptor = view.currentRenderPassDescriptor else {
            fatalError("Unable to source Render Descriptor")
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor) else {
            fatalError("RenderEncoder Setup Failed")
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthStencilState(depthStencilState)
        
        //Draw Call Logic
        renderEncoder.setVertexBuffer(quad.vertexBuffer, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(quad.indexBuffer, offset: 0, index: 1)
        
        renderEncoder.setFragmentTexture(texture, index: 0)
        renderEncoder.setFragmentSamplerState(Renderer.samplerState, index: 0)

        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: quad.indices.count,
            indexType: .uint16,
            indexBuffer: quad.indexBuffer,
            indexBufferOffset: 0)
        //End of Logic
        
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
