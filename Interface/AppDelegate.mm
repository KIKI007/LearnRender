//
//  AppDelegate.m
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#import "AppDelegate.h"
#import <string>


@interface AppDelegate ()
{
    
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _meshes.clear();
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    NSLog(@"Close All Windows");
    _meshes.clear();
    return YES;
}


- (IBAction)Open:(id)sender {
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Multiple files not allowed
    [openDlg setAllowsMultipleSelection:YES];
    
    // Can't select a directory
    [openDlg setCanChooseDirectories:NO];
    
    NSArray* fileTypes = [NSArray arrayWithObjects:@"obj", @"OBj", nil];
    [openDlg setAllowedFileTypes: fileTypes];
    
    // Display the dialog. If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal] == NSModalResponseOK )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* urls = [openDlg URLs];
        
        // Loop through all the files and process them.
        for(int i = 0; i < [urls count]; i++ )
        {
            NSString *url = [NSString stringWithString:[[urls objectAtIndex: i] path]];
            shared_ptr<MeshBase> mesh = make_shared<MeshBase>();
            const char *url_cstr = [url UTF8String];
            mesh->loadOBJ(url_cstr);
            _meshes.push_back(mesh);
        }
    }
}

@end
