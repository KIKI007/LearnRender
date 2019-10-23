//
//  AppDelegate.h
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <memory>
#include <vector>
#include "include/MeshBase.h"

using std::shared_ptr;
using std::make_shared;
using std::vector;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property vector<shared_ptr<MeshBase>> meshes;
@end
