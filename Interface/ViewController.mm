//
//  ViewController.m
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#import "ViewController.h"
#import "MetalRenderer.h"
#import "AppDelegate.h"


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
    _view.clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0);
    
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

- (IBAction)Button:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    vector<shared_ptr<MeshBase>> pMesh = appDelegate.meshes;
    
    _renderer.meshes_position = [NSMutableArray new];
    _renderer.meshes_index = [NSMutableArray new];
    
    for(size_t i = 0; i < pMesh.size(); i++)
    {
        size_t offset = [_renderer.meshes_position count] / 3;
        
        for(size_t j = 0; j < pMesh[i]->V_.rows(); j++)
        {
            float px = (float)pMesh[i]->V_(j, 0);
            float py = (float)pMesh[i]->V_(j, 1);
            float pz = (float)pMesh[i]->V_(j, 2);
            
            [_renderer.meshes_position addObject:[NSNumber numberWithFloat: px]];
            [_renderer.meshes_position addObject:[NSNumber numberWithFloat: py]];
            [_renderer.meshes_position addObject:[NSNumber numberWithFloat: pz]];
        }
        
        for(size_t j = 0; j < pMesh[i]->F_.rows(); j++)
        {
            size_t ix = (size_t)pMesh[i]->F_(j, 0);
            size_t iy = (size_t)pMesh[i]->F_(j, 1);
            size_t iz = (size_t)pMesh[i]->F_(j, 2);
            
            [_renderer.meshes_index addObject:[NSNumber numberWithUnsignedInteger: ix + offset]];
            [_renderer.meshes_index addObject:[NSNumber numberWithUnsignedInteger: iy + offset]];
            [_renderer.meshes_index addObject:[NSNumber numberWithUnsignedInteger: iz + offset]];
        }
    }
    
    NSLog(@"%u", [_renderer.meshes_position count]);
    
    [_renderer buildObjects];
}



@end
