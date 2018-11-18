//
//  TKGLModel.h
//  Tikky
//
//  Created by Le Hoang Vu on 11/18/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLProgram.h"
#import "TKUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface TKGLModel : NSObject

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) GLProgram* glProgram;

- (instancetype)initWithName:(NSString *)name
                     program:(GLProgram *)glProgram
                     texture:(GLuint)textureID
                    vertices:(TKPTVertex *)vertices
                 vertexCount:(int)vertexCount
                     indices:(int *)indices
                  indexCount:(int)indexCount;

- (void)renderWithTextureIndex:(int)textureIndex;

@end

NS_ASSUME_NONNULL_END
