//
//  TKTextureUtilities.h
//  Tikky
//
//  Created by Le Hoang Vu on 11/18/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#ifndef TKTextureUtilities_h
#define TKTextureUtilities_h

typedef struct {
    float r;
    float g;
    float b;
    float a;
} TKColor;

typedef struct {
    float x;
    float y;
    float z;
} TKPosition;

typedef struct {
    float u;
    float v;
} TKTexCoord;

typedef struct {
    TKPosition position;
    TKColor color;
    TKTexCoord texCoord;
} TKPCTVertex;

typedef struct {
    TKPosition position;
    TKTexCoord texCoord;
} TKPTVertex;

typedef struct {
    int textureID;
    TKPTVertex ptVertex[4];
} TKVRectTexture;

typedef struct {
    int textureID;
    TKPosition position[4];
} TKRectTexture;

TKColor TKColorMake(float r, float g, float b, float a);
TKPosition TKPositionMake(float x, float y, float z);
TKTexCoord TKTexCoordMake(float u, float v);
TKPCTVertex TKPCTVertexMake(TKPosition position, TKColor color, TKTexCoord texCoord);
TKPTVertex TKPTVertexMake(TKPosition position, TKTexCoord texCoord);
TKRectTexture TKRectTextureMake(int textureID, TKPosition* position);

#endif /* TKUtilities_h */
