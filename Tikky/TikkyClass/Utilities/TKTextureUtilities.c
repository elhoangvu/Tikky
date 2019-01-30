//
//  TKTextureUtilities.c
//  Tikky
//
//  Created by Le Hoang Vu on 11/18/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#include "TKTextureUtilities.h"

TKColor TKColorMake(float r, float g, float b, float a) {
    TKColor tkColor;
    tkColor.r = r;
    tkColor.g = g;
    tkColor.b = b;
    tkColor.a = a;
    
    return tkColor;
}

TKPosition TKPositionMake(float x, float y, float z) {
    TKPosition tkPosition;
    tkPosition.x = x;
    tkPosition.y = y;
    tkPosition.z = z;
    
    return tkPosition;
}

TKTexCoord TKTexCoordMake(float u, float v) {
    TKTexCoord tkTexCoord;
    tkTexCoord.u = u;
    tkTexCoord.v = v;
    
    return tkTexCoord;
}

TKPCTVertex TKPCTVertexMake(TKPosition position, TKColor color, TKTexCoord texCoord) {
    TKPCTVertex tkpctVertex;
    tkpctVertex.position = position;
    tkpctVertex.color = color;
    tkpctVertex.texCoord = texCoord;
    
    return tkpctVertex;
}

TKPTVertex TKPTVertexMake(TKPosition position, TKTexCoord texCoord) {
    TKPTVertex tkptVertex;
    tkptVertex.position = position;
    tkptVertex.texCoord = texCoord;
    
    return tkptVertex;
}

TKRectTexture TKRectTextureMake(int textureID, TKPosition* position) {
    TKRectTexture tkRectTexture;
    tkRectTexture.textureID = textureID;
    for (int i = 0; i < 4; i++) {
        tkRectTexture.position[i] = position[i];
    }
    
    return tkRectTexture;
}

