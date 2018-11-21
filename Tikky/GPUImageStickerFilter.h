#import "GPUImageOutput.h"
#include "TKUtilities.h"

/** GPUImage's base filter class
 
 Filters and other subsequent elements in the chain conform to the GPUImageInput protocol, which lets them take in the supplied or processed texture from the previous link in the chain and do something with it. Objects one step further down the chain are considered targets, and processing can be branched by adding multiple targets to a single output or filter.
 */
@interface GPUImageStickerFilter : GPUImageFilter {
    std::vector<TKRectTexture>* _textureStickerList;
}

- (void)setTextureStickerList:(std::vector<TKRectTexture> *)textureStickerList;

@end
