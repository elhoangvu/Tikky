//
//  TKCCUtilities.h
//  cocos2d_libs
//
//  Created by Le Hoang Vu on 11/17/18.
//

// <!-- TIKKY-ADD
#ifndef TKCCUtilities_h
#define TKCCUtilities_h

#include "math/Vec2.h"

struct TKPositionsInRect {
    cocos2d::Vec2 topleft;
    cocos2d::Vec2 bottomleft;
    cocos2d::Vec2 topright;
    cocos2d::Vec2 bottomright;
};

struct TKCCTexture {
    GLuint textureID;
    TKPositionsInRect positionsInScene;
    TKCCTexture(GLuint textureID_, TKPositionsInRect positions_)
    : textureID(textureID_)
    , positionsInScene(positions_)
    {}
};

#endif /* TKCCUtilities_h */
// TIKKY-ADD -->
