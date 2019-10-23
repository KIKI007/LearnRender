//
//  MetalRenderer.h
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#import <MetalKit/MetalKit.h>
#import "AAPLMathUtilities.h"

/// Platform-independent renderer class.
@interface MetalRenderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
- (void) buildObjects;

//mesh data

@property NSMutableArray *meshes_position;
@property NSMutableArray *meshes_index;

@end
