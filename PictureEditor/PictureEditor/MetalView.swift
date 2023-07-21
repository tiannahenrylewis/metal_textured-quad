//
//  MetalView.swift
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-17.
//

import SwiftUI
import Metal
import MetalKit

struct MetalView: View {
    @State var metalView: MTKView = MTKView()
    @State var renderer: Renderer?
    
    var body: some View {
        MetalViewRepresentable(metalView: $metalView)
            .onAppear {
                renderer = Renderer(metalView: metalView)
            }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}


#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: NSViewRepresentable {
    @Binding var metalView: MTKView
    
    #if os(macOS)
    func makeNSView(context: Context) -> some NSView {
        metalView
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        updateMetalView()
    }
    #elseif os(iOS)
    func makeUIView(context: Context) -> MTKView {
        metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        updateMetalView()
    }
    #endif
    
    func updateMetalView() {
        print("Update View")
    }
}
