//
//  Shaders.metal
//  PictureEditor
//
//  Created by Tianna Henry-Lewis on 2023-04-17.
//

#include <metal_stdlib>
using namespace metal;

//MARK: - VERTEX DEFINITIONS
struct VertexIn {
    float4 position [[attribute(0)]];
    float2 textureCoordinate [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 textureCoordinate;
};


//MARK: - VERTEX SHADER FUNCTIONS
vertex VertexOut vertex_main(VertexIn in [[stage_in]]) {
    VertexOut out {
        .position = in.position,
        .textureCoordinate = in.textureCoordinate,
    };
    
    return out;
}


//MARK: - FRAGMENT SHADER FUNCTIONS
fragment float4 fragment_main(
                              VertexOut in [[stage_in]],
                              texture2d<float> objectTexture [[texture(0)]]
) {
    //constexpr
    // -> specifies that the value of a variable or function can appear in constant expressions (expressions that can be evaluated at compile time)
    // -> declares that it is possible to evaluate the value of the function or variable at compile time
    constexpr sampler samplerObject;
    float4 color = objectTexture.sample(samplerObject, in.textureCoordinate);
    return float4(color.r, color.g, color.b, 1);
}
