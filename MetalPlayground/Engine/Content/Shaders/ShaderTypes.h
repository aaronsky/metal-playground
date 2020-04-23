/*
 Header containing types and enum constants shared between Metal shaders and C/ObjC source
 */

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum __attribute__ ((enum_extensibility(closed))) VertexAttribute
{
    VertexAttributePosition,
    VertexAttributeNormal,
    VertexAttributeTangent,
    VertexAttributeTexcoord,
} VertexAttribute;

typedef enum __attribute__ ((enum_extensibility(closed))) VertexBufferIndex
{
    VertexBufferIndexAttributes,
    VertexBufferIndexFrameUniforms,
    VertexBufferIndexMeshUniforms,
} VertexBufferIndex;

typedef enum __attribute__ ((enum_extensibility(closed))) FragmentBufferIndex
{
    FragmentBufferIndexVertices,
    FragmentBufferIndexFrameUniforms,
} FragmentBufferIndex;

typedef enum __attribute__ ((enum_extensibility(closed))) TextureIndex
{
    TextureIndexBaseColor,
    TextureIndexMetallic,
    TextureIndexRoughness,
    TextureIndexNormal,
    TextureIndexEmissive,
    TextureIndexIrradiance = 9,
} TextureIndex;

typedef struct FrameUniforms {
    matrix_float4x4 viewProjectionMatrix;
    vector_float3   cameraPosition;
    vector_float3   directionalLightInvDirection;
    vector_float3   lightPosition;
} FrameUniforms;

typedef struct MeshUniforms {
    matrix_float4x4 modelMatrix;
    matrix_float3x3 normalMatrix;
} MeshUniforms;

#endif /* ShaderTypes_h */
