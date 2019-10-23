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
    //metal command
    id<MTLDevice>        _device;
    id<MTLCommandQueue>  _commandQueue;
    id<MTLDepthStencilState>   _depthState;
    
    //metal buffer
    id<MTLBuffer> _positionBuffers;
    id<MTLBuffer>  _indexBuffers;
    
    //pipeline
    id<MTLRenderPipelineState>     _renderPipeline;
    
    //camera
    matrix_float4x4 _cameraMVPMatrix;
    matrix_float4x4 _projectionMatrix;
}


- (void) updateFrameState
{
    float rotation = 0;
    vector_float3   cameraPosition = {0.0, 0.0, -2.0};
    matrix_float4x4 cameraViewMatrix  = matrix4x4_translation(cameraPosition);
    
    vector_float3   templeRotationAxis      = {0, 1, 0};
    matrix_float4x4 templeRotationMatrix    = matrix4x4_rotation (rotation, templeRotationAxis);
    matrix_float4x4 templeTranslationMatrix = matrix4x4_translation(0.0, -4, 0);
    matrix_float4x4 templeModelMatrix       = matrix_multiply(templeRotationMatrix, templeTranslationMatrix);
    matrix_float4x4 templeModelViewMatrix   = matrix_multiply (cameraViewMatrix, templeModelMatrix);
    
    _cameraMVPMatrix     = matrix_multiply(_projectionMatrix, templeModelViewMatrix);
    
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
     
        [self buildObjects];
        
        [self updateFrameState];
        
    }
    return self;
}

- (void) buildObjects{
        // In Metal, there's no equivalent to a vertex array object. Instead, you define the layout of the
        // vertices with a render pipeline state object.
        // In this case, you create a vertex descriptor that defines the vertex layout which you set in
        // the render pipeline state object for the temple model. See `mtlVertexDescriptor` below for more
        // information.
    
        // Create Metal buffers to store the vertex data (i.e. positions, texture coordinates, and normals).
    
        NSError *error;
    
        if(_meshes_position && _meshes_index)
        {
            NSUInteger positionElementSize = sizeof(vector_float3);
            NSUInteger positionDataSize    = positionElementSize * [_meshes_position count];
            
            if(positionDataSize > 0){
                _positionBuffers =  [_device newBufferWithLength:positionDataSize
                                                         options:MTLResourceStorageModeShared];
                
                vector_float3 *positionsArray = (vector_float3 *)_positionBuffers.contents;
                
                for(unsigned long vertex = 0; vertex < [_meshes_position count] / 3; vertex++)
                {
                    float px = [[_meshes_position objectAtIndex: (vertex * 3)] floatValue];
                    float py = [[_meshes_position objectAtIndex: vertex * 3 + 1] floatValue];
                    float pz = [[_meshes_position objectAtIndex: vertex * 3 + 2] floatValue];
                    positionsArray[vertex] = simd_make_float3(px, py, pz);
                }
            }
            
            NSUInteger indexElementSize = sizeof(unsigned int);
            NSUInteger indexDataSize    = indexElementSize * [_meshes_index count];
            
            if(indexDataSize > 0){
                _indexBuffers = [_device newBufferWithLength:indexDataSize options:MTLResourceStorageModeShared];
                
                unsigned int *indexArray = (unsigned int *)_indexBuffers.contents;
                for(unsigned long index = 0; index < [_meshes_index count]; index++)
                {
                    indexArray[index] =  [[_meshes_index objectAtIndex: index] unsignedIntValue];
                }
            }
        }
    
    {
        MTLVertexDescriptor *mtlVertexDescriptor = [[MTLVertexDescriptor alloc] init];
        
        // Positions.
        mtlVertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
        mtlVertexDescriptor.attributes[0].offset = 0;
        mtlVertexDescriptor.attributes[0].bufferIndex = 0;
        
    
        // Position buffer layout.
        mtlVertexDescriptor.layouts[0].stride = 16;
        mtlVertexDescriptor.layouts[0].stepRate = 1;
        mtlVertexDescriptor.layouts[0].stepFunction = MTLVertexStepFunctionPerVertex;
        
        // Configure a pipeline descriptor that enables the creation of an immutable pipeline state object.
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineStateDescriptor.label                        = @"Temple Pipeline";
        
        // Load the library of precompiled shaders.
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        
        // Load the precompiled vertex and fragment shaders from the library.
        id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"simpleVertexShader"];
        id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"simpleFragmentShader"];
        
        // Set the vertex input descriptor, vertex shader, and fragment shader for this pipeline object.
        pipelineStateDescriptor.vertexDescriptor = mtlVertexDescriptor;
        pipelineStateDescriptor.vertexFunction = vertexFunction;
        pipelineStateDescriptor.fragmentFunction = fragmentFunction;
        
        // Set the render target formats that this pipeline renders to. Unlike OpenGL program objects,
        // where any program can render to any framebuffer object, Metal pipeline objects can render only
        // to the set of render target using the pixel formats that they're built for. By linking the
        // formats to the pipeline, Metal can optimize the fragment shader for those specific formats when
        // the app creates the pipeline object.
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
        pipelineStateDescriptor.depthAttachmentPixelFormat      = MTLPixelFormatDepth32Float;
        
        // Use the settings in `pipelineStateDescriptor` to create the immutable pipeline state.
        _renderPipeline = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                        error:&error];
        
        NSAssert(_renderPipeline, @"Failed to create temple render pipeline state, error: %@.", error);
    }
        
}

- (void)drawInMTKView:(nonnull MTKView *)view {
    
    
    [self updateFrameState];
    
    // The render pass descriptor references the texture into which Metal should draw
    id<MTLCommandBuffer> commandBuffer;
    commandBuffer = [_commandQueue commandBuffer];
    
    MTLRenderPassDescriptor *drawableRenderPassDescriptor = view.currentRenderPassDescriptor;
    
    if(drawableRenderPassDescriptor != nil)
    {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor: drawableRenderPassDescriptor];
        
        [renderEncoder setRenderPipelineState:_renderPipeline];
        [renderEncoder setDepthStencilState:_depthState];
        
        
        [renderEncoder setVertexBuffer:_positionBuffers
                                offset:0
                               atIndex:0];
        
        [renderEncoder setVertexBytes:&_cameraMVPMatrix
                                length:sizeof(_cameraMVPMatrix)
                                atIndex:1];
        
        if(_meshes_index && [_meshes_index count] > 0){
            [renderEncoder drawIndexedPrimitives:  MTLPrimitiveTypeTriangle
                                      indexCount:  [_meshes_index count]
                                       indexType:   MTLIndexTypeUInt32
                                     indexBuffer: _indexBuffers
                               indexBufferOffset:0];
        }
       
        
        
        // End encoding commands.
        [renderEncoder endEncoding];
        
        // Get the drawable that will be presented at the end of the frame
        
        
        // Request that the drawable texture be presented by the windowing system once drawing is done
        [commandBuffer presentDrawable:view.currentDrawable];
        
    }
    
    [commandBuffer commit];
}


- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    float aspect = size.width / (float)size.height;
    _projectionMatrix = matrix_perspective_left_hand(65.0f * (M_PI / 180.0f), aspect, 1.0f, 5000.0);
}






@end
