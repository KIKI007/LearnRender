//
//  AppDelegate.m
//  LearnRender
//
//  Created by ziqwang on 19.10.19.
//  Copyright © 2019 ziqwang. All rights reserved.
//

#import "AppDelegate.h"
#import "Greeting.hpp"
#import <string>

@interface AppDelegate ()
{
    
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
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
            readOBJ([url UTF8String]);
        }
    }
}


































-(void)convertNSString:( NSString* )absoluteString
           toStlString:( std::string& )urlCppString_
{
    if ( nil != absoluteString )
    {
        std::string tmpUrlCppString
        (
         [absoluteString cStringUsingEncoding: NSUTF8StringEncoding],
         [absoluteString lengthOfBytesUsingEncoding: NSUTF8StringEncoding]
         );

        urlCppString_ = tmpUrlCppString;
    }
}

@end
