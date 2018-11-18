//
//  TKGLModel.m
//  Tikky
//
//  Created by Le Hoang Vu on 11/18/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKGLModel.h"

@interface TKGLModel () {
//    TKPTVertex* _vertices;
//    int _vertexCount;
//    int* _indices;
//    int _indexCount;
    
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    int _textureUniform;
    int _indexCount;
    GLuint _texture;
}

@end

@implementation TKGLModel

- (instancetype)initWithName:(NSString *)name
                     program:(GLProgram *)glProgram
                     texture:(GLuint)textureID
                    vertices:(TKPTVertex *)vertices
                 vertexCount:(int)vertexCount
                     indices:(int *)indices
                  indexCount:(int)indexCount {
    if (!(self = [super init])) {
        return nil;
    }
    
    _name       = name;
    _glProgram  = glProgram;
    _indexCount = indexCount;
    _texture = textureID;
    
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(vertices[0]), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ARRAY_BUFFER, indexCount * sizeof(indices[0]), indices, GL_STATIC_DRAW);
    
    [_glProgram addAttribute:@"a_position"];
    GLuint positionAttr = [_glProgram attributeIndex:@"a_position"];
    glEnableVertexAttribArray(positionAttr);
    glVertexAttribPointer(
                          positionAttr,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(vertices[0]),
                          vertices + offsetof(TKPTVertex, position));
    
    [_glProgram addAttribute:@"a_texCoord"];
    GLuint texCoordAttr = [_glProgram attributeIndex:@"a_texCoord"];
    glEnableVertexAttribArray(texCoordAttr);
    glVertexAttribPointer(
                          texCoordAttr,
                          2,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(vertices[0]),
                          vertices + offsetof(TKPTVertex, texCoord));
    
    glBindVertexArrayOES(_vao);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    _textureUniform = [_glProgram uniformIndex:@"s_texture"];
    
    return self;
}

- (void)renderWithTextureIndex:(int)textureIndex {
    if (!_glProgram) {
        return;
    }
    
    [_glProgram use];
    
    glActiveTexture(GL_TEXTURE0 + textureIndex);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(_textureUniform, 0);
    
    glBindVertexArrayOES(_vao);
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_BYTE, nil);
    glBindVertexArrayOES(0);
    
}

@end
