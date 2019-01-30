#import "GPUImageOutput.h"
#include "TKTextureUtilities.h"

/**
 A filter to add stickers from external textures to GPUImage Engine
 */
@interface GPUImageStickerFilter : GPUImageFilter {
    NSData* _textureStickers;
}

/**
 Set textures for the filter

 @param textureStickers A NSData wrapper for array of TKRectTexture
 @see
     TKRectTexture* rectTexture = (TKRectTexture *)malloc(sizeof(TKRectTexture)*textureList->size());
     // set data for TKRectTexture array: rectTexture
     NSData* textureStickers = [NSData dataWithBytesNoCopy:rectTexture length:textureList->size() freeWhenDone:YES];

     [GPUImageStickerFilter setTextureStickers:textureStickers];
 */
- (void)setTextureStickers:(NSData *)textureStickers;

@end
