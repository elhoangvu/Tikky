#import "GPUImageStickerFilter.h"
#import "GPUImagePicture.h"
#import <AVFoundation/AVFoundation.h>

#define GL_MAX_TEXTURE 6

// Hardcode the vertex shader for standard filters, but this can be overridden
NSString *const kGPUImageVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

NSString *const kGPUImagePassthroughFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
 }
);

#else

NSString *const kGPUImagePassthroughFragmentShaderString = SHADER_STRING
(
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
 }
);
#endif


@implementation GPUImageStickerFilter

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _textureStickers = nil;
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
{
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
    }
    [GPUImageContext useImageProcessingContext];
    [GPUImageContext setActiveShaderProgram:filterProgram];

    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }

    [self setUniformsForProgramAtIndex:0];
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    
    static const GLfloat imageVertices3[] = {
        -0.25f, -0.25f,
        0.25f, -0.25f,
        -0.25f,  0.25f,
        0.25f,  0.25f,
    };
    
    static const GLfloat imageVertices2[] = {
        -0.75f, -0.75f,
        0.75f, -0.75f,
        -0.75f,  0.75f,
        0.75f,  0.75f,
    };
    //----->
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
    
    glUniform1i(filterInputTextureUniform, 2);
    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    TKRectTexture* rectTextures = (TKRectTexture *)_textureStickers.bytes;
    NSUInteger size = _textureStickers.length;
    if (rectTextures) {
        for (int i = 0; i < size; i++) {
            glActiveTexture(GL_TEXTURE2 + (i + 1) % (GL_MAX_TEXTURE - 2));
            NSLog(@"Texture id: %d", rectTextures[i].textureID);
            glBindTexture(GL_TEXTURE_2D, rectTextures[i].textureID);
            
            glUniform1i(filterInputTextureUniform, 2 + (i + 1) % (GL_MAX_TEXTURE - 2));
            
            glVertexAttribPointer(filterPositionAttribute, 3, GL_FLOAT, 0, 0, rectTextures[i].position);
            glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        }
    }
    
//    //----->

//    //----->
//    glActiveTexture(GL_TEXTURE2);
//    glBindTexture(GL_TEXTURE_2D, 3);
//    
//    glUniform1i(filterInputTextureUniform, 2);
//    
//    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, imageVertices3);
//    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
//  
//    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//    //----->
    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }
}

- (void)setTextureStickers:(NSData *)textureStickers {
    _textureStickers = textureStickers;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    static const GLfloat imageVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    [self renderToTextureWithVertices:imageVertices textureCoordinates:[[self class] textureCoordinatesForRotation:inputRotation]];
    glDisable(GL_BLEND);
    [self informTargetsAboutNewFrameAtTime:frameTime];
}

@end
