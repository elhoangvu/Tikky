//
//  GPUImageStickerFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/17/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "GPUImageStickerOuput.h"

NSString* const kTikkyStickerFragmentShaderString = SHADER_STRING
(
 attribute vec4 a_position;
 attribute vec2 a_texCoord;
 attribute vec4 a_color;
 
#ifdef GL_ES
 varying lowp vec4 v_fragmentColor;
 varying mediump vec2 v_texCoord;
#else
 varying vec4 v_fragmentColor;
 varying vec2 v_texCoord;
#endif
 
 void main()
{
    gl_Position = CC_MVPMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;
}
 );

NSString* const kTikkyStickerVertexShaderString = SHADER_STRING
(
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

void main()
{
    gl_Position = CC_MVPMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;
}
);

@interface GPUImageStickerOuput ()

@end

@implementation GPUImageStickerOuput

- (instancetype)initWithQueuedTriangleCommands:(std::vector<int> * __nullable)queuedTriangleCommands {
    if (!(self = [super init])) {
        return nil;
    }
    
    _queuedTriangleCommands = queuedTriangleCommands;
    
    return self;
}

- (instancetype)init
{
    if (!(self = [self initWithQueuedTriangleCommands:nil]))
    {
        return nil;
    }
    
    return self;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
    
//    [self informTargetsAboutNewFrameAtTime:frameTime];
}

@end
