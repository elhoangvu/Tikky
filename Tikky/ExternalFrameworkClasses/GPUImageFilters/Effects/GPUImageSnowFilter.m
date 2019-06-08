//
//  GPUImageSnowFilter.m
//  GlitchFilter
//
//  Created by Le Hoang Vu on 3/26/19.
//  Copyright © 2019 Le Hoang Vu. All rights reserved.
//

#import "GPUImageSnowFilter.h"

#define kFPS 30

NSString *const kGPUImageSnowFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D inputImageTexture;
 uniform vec2 iResolution;
 uniform float iTime;
 
 varying vec2 textureCoordinate;
 
 #define pi 3.1415926
 
 float T;
 
 // iq's hash function from https://www.shadertoy.com/view/MslGD8
 vec2 hash(vec2 p) {
     p = vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3)));
     return fract(sin(p)*18.5453);
 }
 
 float simplegridnoise(vec2 v) {
    float s = 1. / 256.;
    vec2 fl = floor(v);
    vec2 fr = fract(v);
    float mindist = 1e9;
    for(int y = -1; y <= 1; y++)
        for(int x = -1; x <= 1; x++) {
            vec2 offset = vec2(x, y);
            vec2 pos = .5 + .5 * cos(2. * pi * (T*.1 + hash(fl+offset)) + vec2(0,1.6));
            mindist = min(mindist, length(pos+offset -fr));
        }
    
    return mindist;
}
 
 float blobnoise(vec2 v, float s) {
    return pow(.5 + .5 * cos(pi * clamp(simplegridnoise(v)*2., 0., 1.)), s);
 }
 
 float fractalblobnoise(vec2 v, float s) {
    float val = 0.;
    const float n = 4.;
    for(float i = 0.; i < n; i++)
        val += pow(0.5, i+1.) * blobnoise(exp2(i) * v + vec2(0, T), s);
    
    return val;
 }
 
 void main() {
    T = iTime;
    
    vec2 r = vec2(1.0, iResolution.y / iResolution.x);
    vec2 uv = textureCoordinate.xy;
    float val = fractalblobnoise(r * uv * (iResolution.x/400.), iResolution.x/50.);
     vec4 color = texture2D(inputImageTexture, uv);

    gl_FragColor = mix(color, vec4(1.0), vec4(val));
 }
);

@interface GPUImageSnowFilter () {
    GLuint _resolutionUniform;
    GLuint _timeUniform;
}

@property (nonatomic) CGFloat timeDelta;
@property (nonatomic) GPUVector2 resolution;
@property (nonatomic) CADisplayLink* displayLink;
@property (nonatomic) NSInteger lastTextureIndex;

@end

@implementation GPUImageSnowFilter

- (instancetype)init {

    if (!(self = [super initWithFragmentShaderFromString:kGPUImageSnowFragmentShaderString])) {
        return nil;
    }
    
    self.stillImage = YES;
    self.timeDelta = 10000;
    self.speed = 50.;
    
    _timeUniform = [filterProgram uniformIndex:@"iTime"];
    _resolutionUniform = [filterProgram uniformIndex:@"iResolution"];

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(doCaller)];
    
    if (@available(iOS 10.0, *)) {
        _displayLink.preferredFramesPerSecond = kFPS;
    } else {
        _displayLink.frameInterval = 1.0/kFPS;
    }
    
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    return self;
}

- (void)doCaller {
    NSLog(@">>>> HV > %f", _timeDelta);
    self.timeDelta -= 1.0/self.speed;
    if (!_stillImage) {
        [super newFrameReadyAtTime:kCMTimeZero atIndex:_lastTextureIndex];
    }
}

- (void)setResolution:(GPUVector2)resolution {
    _resolution = resolution;
    
    [self setVec2:_resolution forUniform:_resolutionUniform program:filterProgram];
}

- (void)setTimeDelta:(CGFloat)timeDelta {
    _timeDelta = timeDelta;
    
    [self setFloat:_timeDelta forUniform:_timeUniform program:filterProgram];
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex {
    [super setInputSize:newSize atIndex:textureIndex];
    GPUVector2 vec2;
    vec2.one = newSize.width;
    vec2.two = newSize.height;
    
    self.resolution = vec2;
    _lastTextureIndex = textureIndex;
}

- (void)dealloc {
    [_displayLink invalidate];
}

- (void)randomTime {
    self.timeDelta = 1.0/self.speed * (rand() % 10000);
}

@end
