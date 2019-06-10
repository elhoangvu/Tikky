//
//  OpenCVUtilities.m
//  Tikky
//
//  Created by Le Hoang Vu on 1/31/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "OpenCVUtilities.h"

void rotate(cv::Mat& src, double angle, cv::Mat& dst)
{
    cv::Point2f pt(src.cols/2., src.rows/2.);
    cv::Mat r = cv::getRotationMatrix2D(pt, angle, 1.0);
    cv::warpAffine(src, dst, r, cv::Size(src.cols, src.rows));
}

@implementation OpenCVUtilities

+ (cv::Mat)matFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    void* bufferAddress;
    size_t width;
    size_t height;
    size_t bytesPerRow;
    
    int format_opencv;
    
    OSType format = CVPixelBufferGetPixelFormatType(imageBuffer);
    if (format == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        
        format_opencv = CV_8UC1;
        
        bufferAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
        height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
        bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
        
    } else { // expect kCVPixelFormatType_32BGRA
        
        format_opencv = CV_8UC4;
        
        bufferAddress = CVPixelBufferGetBaseAddress(imageBuffer);
        width = CVPixelBufferGetWidth(imageBuffer);
        height = CVPixelBufferGetHeight(imageBuffer);
        bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        
    }
    
    // delegate image processing to the delegate
    cv::Mat image((int)height, (int)width, format_opencv, bufferAddress, bytesPerRow);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
}

+ (void)rotateImage:(cv::Mat &)src angle:(float)angle dst:(cv::Mat &)dst {
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    if (angle == 0) {
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@">>>> HV > rotation time: %f", end - start);
        dst = src.clone();
        return;
    }
    // Make larger image
    int rows = src.rows;
    int cols = src.cols;
    int largest = 0;
    if ( rows > cols ){
        largest = rows;
    }else{
        largest = cols;
    }
    
    cv::Mat temp = cv::Mat::zeros(largest, largest, src.type());
    
    // Copy your original image
    // First define the roi in the large image --> draw this on a paper to make it clear
    // There are two possible cases
    cv::Rect roi;
    if (src.rows > src.cols){
        roi = cv::Rect((temp.cols - src.cols)/2, 0, src.cols, src.rows);
    }
    if (src.cols > src.rows){
        roi = cv::Rect(0, (temp.rows - src.rows)/2, src.cols, src.rows);
    }
    
    // Copy the original to the black large temp image
    src.copyTo(temp(roi));
    
    // Rotate the image
    cv::Mat rotated = temp.clone();
    rotate(temp, -90, rotated);
    
    // Now cut it out again
    dst = rotated(cv::Rect(roi.y, roi.x, roi.height, roi.width)).clone();
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@">>>> HV > rotation time: %f", end - start);
}

@end
