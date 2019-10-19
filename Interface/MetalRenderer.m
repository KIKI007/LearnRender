//
//  MetalRenderer.m
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//
#import "MetalRenderer.h"

@import simd;
@import ModelIO;
@import MetalKit;

@implementation MetalRenderer
{
    id<MTLDevice>        _device;
    id<MTLCommandQueue>  _commandQueue;
    id<MTLDepthStencilState>   _depthState;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView
{
    self = [super init];
    if(self)
    {
        _device = mtkView.device;
        _commandQueue = [_device newCommandQueue];
        mtkView.colorPixelFormat        = MTLPixelFormatBGRA8Unorm_sRGB;
        mtkView.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        
        {
            // Configure a combined depth and stencil descriptor that enables the creation
            // of an immutable depth and stencil state object.
            MTLDepthStencilDescriptor *depthStencilDesc = [[MTLDepthStencilDescriptor alloc] init];
            depthStencilDesc.depthCompareFunction = MTLCompareFunctionLess;
            depthStencilDesc.depthWriteEnabled = YES;
            _depthState = [_device newDepthStencilStateWithDescriptor:depthStencilDesc];
    
        }
     
        
    }
    return self;
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    
    // The render pass descriptor references the texture into which Metal should draw
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor == nil)
    {
        return;
    }

    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // Create a render pass and immediately end encoding, causing the drawable to be cleared
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    
    [commandEncoder endEncoding];
    
    // Get the drawable that will be presented at the end of the frame

    id<MTLDrawable> drawable = view.currentDrawable;

    // Request that the drawable texture be presented by the windowing system once drawing is done
    [commandBuffer presentDrawable:drawable];
    
    [commandBuffer commit];
    
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}


@end
