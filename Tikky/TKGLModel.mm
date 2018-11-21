////
////  TKGLModel.m
////  Tikky
////
////  Created by Le Hoang Vu on 11/18/18.
////  Copyright © 2018 Le Hoang Vu. All rights reserved.
////
//
//#import "TKGLModel.h"
//
//@interface TKGLModel () {
////    TKPTVertex* _vertices;
////    int _vertexCount;
////    int* _indices;
////    int _indexCount;
//    
//    GLuint _vao;
//    GLuint _vertexBuffer;
//    GLuint _indexBuffer;
//    int _textureUniform;
//    int _indexCount;
//    GLuint _texture;
//    int _indices[6];
//}
//
//@end
//
//@implementation TKGLModel
//
//- (instancetype)initWithName:(NSString *)name
//                     program:(GLProgram *)glProgram
//                     texture:(GLuint)textureID
//                    vertices:(TKPTVertex *)vertices
//                 vertexCount:(int)vertexCount
//                     indices:(int *)indices
//                  indexCount:(int)indexCount {
//    if (!(self = [super init])) {
//        return nil;
//    }
//    
//    _name       = name;
//    _glProgram  = glProgram;
//    _indexCount = indexCount;
//    _texture = textureID;
//    for (int i = 0; i < 6; i++) {
//        _indices[i] = indices[i];
//    }
//    
//    glGenVertexArraysOES(1, &_vao);
//    glBindVertexArrayOES(_vao);
//    
//    glGenBuffers(1, &_vertexBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//    glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(vertices[0]), vertices, GL_STATIC_DRAW);
//    
//    glGenBuffers(1, &_indexBuffer);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(indices[0]), indices, GL_STATIC_DRAW);
//    
//    [_glProgram addAttribute:@"a_position"];
//    GLuint positionAttr = [_glProgram attributeIndex:@"a_position"];
//    glEnableVertexAttribArray(positionAttr);
//  
//    glVertexAttribPointer(
//                          positionAttr,
//                          3,
//                          GL_FLOAT,
//                          GL_FALSE,
//                          sizeof(vertices[0]),
//                          vertices + offsetof(TKPTVertex, position));
//    
//    [_glProgram addAttribute:@"a_texCoord"];
//    GLuint texCoordAttr = [_glProgram attributeIndex:@"a_texCoord"];
//    glEnableVertexAttribArray(texCoordAttr);
//    glVertexAttribPointer(
//                          texCoordAttr,
//                          2,
//                          GL_FLOAT,
//                          GL_FALSE,
//                          sizeof(vertices[0]),
//                          vertices + offsetof(TKPTVertex, texCoord));
//    
//    glBindVertexArrayOES(0);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
//    
//    if (!_glProgram.initialized)
//    {
//        if (![_glProgram link])
//        {
//            NSString *progLog = [_glProgram programLog];
//            NSLog(@"Program link log: %@", progLog);
//            NSString *fragLog = [_glProgram fragmentShaderLog];
//            NSLog(@"Fragment shader compile log: %@", fragLog);
//            NSString *vertLog = [_glProgram vertexShaderLog];
//            NSLog(@"Vertex shader compile log: %@", vertLog);
//            _glProgram = nil;
//            NSAssert(NO, @"Filter shader link failed");
//        }
//    }
//        
//    _textureUniform = [_glProgram uniformIndex:@"u_texture"];
//    
//    return self;
//}
//
//- (void)renderWithTextureIndex:(int)textureIndex {
//    if (!_glProgram) {
//        return;
//    }
//    [GPUImageContext setActiveShaderProgram:_glProgram];
//    [_glProgram use];
//
//    
//    glActiveTexture(GL_TEXTURE0);
//    glBindTexture(GL_TEXTURE_2D, _texture);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//    
//    glUniform1i(_textureUniform, 0);
//    
//    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
//    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
//    
//    glBindVertexArrayOES(_vao);
//    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_BYTE, nil);
//    glBindVertexArrayOES(0);
//    
//}
//
//@end
