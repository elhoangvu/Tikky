//
//  TKImageFilter.m
//  Tikky
//
//  Created by Le Hoang Vu on 12/4/18.
//  Copyright © 2018 Le Hoang Vu. All rights reserved.
//

#import "TKImageFilter.h"
#import "GPUImage.h"

@interface TKImageFilter ()

@property (nonatomic) GPUImageOutput* gpuimageOutput;
@property (nonatomic) GPUImageFilterGroup* gpuimageFilterGroup;
@property (nonatomic) GPUImageView* gpuimageView;

@property (nonatomic) NSMutableDictionary* filterList;
@property (nonatomic) NSMutableDictionary* lookupFilterList;

@end

@implementation TKImageFilter

@synthesize view = view;

- (instancetype)init
{
    if (!(self = [self initWithInput:[[TKCamera alloc] init] filter:@"default"])) {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithInput:(TKImageInput *)input filter:(NSString *)filter {
    if (!(self = [super init])) {
        return nil;
    }
    
    _filterList = [NSMutableDictionary dictionary];
    _lookupFilterList = [NSMutableDictionary dictionary];
    
    [_filterList setObject:@"GPUImageBrightnessFilter" forKey:@"BRIGHTNESS"];
    [_filterList setObject:@"GPUImageLevelsFilter" forKey:@"LEVELS"];
    [_filterList setObject:@"GPUImageSaturationFilter" forKey:@"SATURATION"];
    [_filterList setObject:@"GPUImageContrastFilter" forKey:@"CONTRAST"];
    [_filterList setObject:@"GPUImageGammaFilter" forKey:@"GAMMA"];
    [_filterList setObject:@"GPUImageFilter" forKey:@"DEFAULT"];
    
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    [_lookupFilterList setObject:@"" forKey:@""];
    
    _gpuimageOutput = nil;
    _gpuimageFilterGroup = [[GPUImageFilterGroup alloc] init];
    GPUImageFilter* defaultFilter = [[GPUImageFilter alloc] init];
    _gpuimageFilterGroup.initialFilters = [NSArray arrayWithObject:defaultFilter];
    _gpuimageFilterGroup.terminalFilter = defaultFilter;
    self.input = input;
    
    _gpuimageView = [[GPUImageView alloc] init];
    view = _gpuimageView;
    [defaultFilter addTarget:_gpuimageView];

    return self;
}

#pragma mark - Properties's getter, setter

- (EAGLSharegroup *)sharegroup {
    return [[[GPUImageContext sharedImageProcessingContext] context] sharegroup];
}

- (void)setInput:(TKImageInput *)input {
    if (!(input
          || [input isKindOfClass:TKCamera.class]
          || [input isKindOfClass:TKMovie.class]
          || [input isKindOfClass:TKPhoto.class]
          || input.publicObject)) {
        return;
    }
    if ([_gpuimageOutput isKindOfClass:GPUImageVideoCamera.class]) {
        GPUImageVideoCamera* videoCamera = (GPUImageVideoCamera *)_gpuimageOutput;
        [videoCamera stopCameraCapture];
    }
    if (_gpuimageOutput) {
        [_gpuimageOutput removeAllTargets];
    }
    _gpuimageOutput = (GPUImageOutput *)input.publicObject;
    [_gpuimageOutput addTarget:[_gpuimageFilterGroup.initialFilters firstObject]];
    _input = input;
}

- (void)setFilter:(NSString *)filter {
    NSString* uppercaseFilter = filter.uppercaseString;
    NSString* filterClass = [_filterList objectForKey:uppercaseFilter];
    if (!filterClass || [filterClass isEqualToString:@""]) {
        
        _filter = nil;
        return;
    }
    
    if (_gpuimageFilterGroup.terminalFilter) {
        [_gpuimageFilterGroup.terminalFilter removeTarget:_gpuimageView];
    }
    
    GPUImageFilter* filterInstance = (GPUImageFilter *)[[NSClassFromString(filterClass) alloc] init];
    _gpuimageFilterGroup.initialFilters = [NSArray arrayWithObject:filterInstance];
    _gpuimageFilterGroup.terminalFilter = filterInstance;
    [filterInstance addTarget:_gpuimageView];
}

@end
