//
//  UIImage+CVPixelBufferRefConverter.m
//  Tikky
//
//  Created by Le Hoang Vu on 2/2/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "UIImage+CVPixelBufferRefConverter.h"

@implementation UIImage (CVPixelBufferRefConverter)

- (CVPixelBufferRef)CVPixelBufferRef {
    CGImageRef image = self.CGImage;
    CGSize frameSize = self.size; // Not sure why this is even necessary, using CGImageGetWidth/Height in status/context seems to work fine too
    
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width, frameSize.height, kCVPixelFormatType_32ARGB, nil, &pixelBuffer);
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, frameSize.width, frameSize.height, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}

@end
