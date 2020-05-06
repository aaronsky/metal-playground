
#include <metal_stdlib>

using namespace metal;

#include <simd/simd.h>
#include "../ShaderTypes.h"

struct Vertex
{
    float3 position [[ attribute(VertexAttributePosition) ]];
    float3 normal   [[ attribute(VertexAttributeNormal) ]];
    float3 tangent  [[ attribute(VertexAttributeTangent) ]];
    float2 texCoord [[ attribute(VertexAttributeTexcoord) ]];
};

struct ColorInOut
{
    float4 position [[ position ]];
    float3 worldPosition;
    float3 normal;
    float3 tangent;
    float3 bitangent;
    float2 texCoord;
};

vertex ColorInOut basicVertex(Vertex in [[stage_in]],
                              constant FrameUniforms & frameUniforms [[ buffer(VertexBufferIndexFrameUniforms) ]],
                              constant MeshUniforms & meshUniforms [[ buffer(VertexBufferIndexMeshUniforms) ]])
{
    
    ColorInOut out;
    
    out.position = frameUniforms.viewProjectionMatrix * meshUniforms.modelMatrix * float4(in.position, 1.0);
    out.worldPosition = (meshUniforms.modelMatrix * float4(in.position, 1.0)).xyz;
    out.normal = meshUniforms.normalMatrix * in.normal;
    out.tangent = meshUniforms.normalMatrix * in.tangent;
    out.bitangent = meshUniforms.normalMatrix * cross(in.normal, in.tangent);
    out.texCoord = in.texCoord;
    
    return out;
}

fragment float4 basicFragment(ColorInOut in [[stage_in]],
                              constant FrameUniforms & frameUniforms [[ buffer(FragmentBufferIndexFrameUniforms) ]],
                              texture2d<float>         baseColorMap  [[ texture(TextureIndexBaseColor) ]],
                              texture2d<float>         metallicMap   [[ texture(TextureIndexMetallic) ]],
                              texture2d<float>         roughnessMap  [[ texture(TextureIndexRoughness) ]],
                              texture2d<float>         normalMap     [[ texture(TextureIndexNormal) ]],
                              texture2d<float>         emissiveMap   [[ texture(TextureIndexEmissive) ]],
                              texturecube<float>       irradianceMap [[ texture(TextureIndexIrradiance) ]])
{
    constexpr sampler linearSampler(mip_filter::linear, mag_filter::linear, min_filter::linear);
    
    float4 baseColor = baseColorMap.sample(linearSampler, in.texCoord);
    
    float nDotL = saturate(dot(in.normal, frameUniforms.directionalLightInvDirection));
    float3 diffuseTerm = float3(0.8) * nDotL;
    float3 directionalContribution = (diffuseTerm + float3(0.05));
    float3 color = directionalContribution * baseColor.xyz;
    
    return float4(color, baseColor.w);
}

