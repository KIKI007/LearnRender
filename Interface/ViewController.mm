//
//  ViewController.m
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#import "ViewController.h"
#import "MetalRenderer.h"
#import "Greeting.hpp"
@interface ViewController ()
{
    
}
@end

@implementation ViewController
{
    MTKView *_view;

    MetalRenderer *_renderer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the view to use the default device.
    _view = (MTKView *)self.view;
    _view.device = MTLCreateSystemDefaultDevice();
    _view.clearColor = MTLClearColorMake(0.0, 0.5, 1.0, 1.0);
    
    if(!_view.device)
    {
        assert(!"Metal is not supported on this device.");
        return;
    }

    _renderer = [[MetalRenderer alloc] initWithMetalKitView:_view];

    if(!_renderer)
    {
        assert(!"Renderer failed initialization.");
        return;
    }

    // Initialize renderer with the view size.
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];

    _view.delegate = _renderer;
}
@end
