//
//  GPUImageFilter+GPUVector2.h
//  GlitchFilter
//
//  Created by Le Hoang Vu on 3/4/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "GPUImageFilter.h"

typedef struct GPUVector2 {
    GLfloat one;
    GLfloat two;
} GPUVector2;

@interface GPUImageFilter (GPUVector2)

- (void)setVec2:(GPUVector2)vectorValue forUniform:(GLint)uniform program:(GLProgram *)shaderProgram;

@end

