//
//  GPUImageFilter+GPUVector2.m
//  GlitchFilter
//
//  Created by Le Hoang Vu on 3/4/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "GPUImageFilter+GPUVector2.h"

@implementation GPUImageFilter (GPUVector2)

- (void)setVec2:(GPUVector2)vectorValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram
{
    runAsynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:shaderProgram];
        
        [self setAndExecuteUniformStateCallbackAtIndex:uniform forProgram:shaderProgram toBlock:^{
            glUniform2fv(uniform, 1, (GLfloat *)&vectorValue);
        }];
    });
}

@end
