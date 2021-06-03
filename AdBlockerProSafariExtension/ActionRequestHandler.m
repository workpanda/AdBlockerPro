//
//  ActionRequestHandler.m
//  AdBlockerProSafariExtension
//
//  Created by Passion on 10/6/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "ActionRequestHandler.h"
#import "AdBlockManager.h"
#import "Constant.h"


@interface ActionRequestHandler ()

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    AdBlockManager* adManager = [[AdBlockManager alloc] init];
    
    adManager.activated = YES;
    
    NSURL *groupURL = [[NSFileManager defaultManager]
                       containerURLForSecurityApplicationGroupIdentifier:
                       kGroupName];
    
    NSURL* urlPath = nil;

    if (!adManager.enabled)
    {
        urlPath = [[NSBundle mainBundle] URLForResource:@"emptyList" withExtension:@"json"];
    }
    else
    {
        NSLog(@"group path: %@", groupURL.path);

        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager changeCurrentDirectoryPath:groupURL.path];
        
        NSData* data = [fileManager contentsAtPath:@"blockerList.json"]; // works fine.
        NSData* dataNew = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:@"blockerList.json" isDirectory:NO relativeToURL:groupURL]];
        
        NSLog(@"file exist");
    }
    
    
    NSItemProvider *attachment = [[NSItemProvider alloc] initWithContentsOfURL:[NSURL fileURLWithPath:@"blockerList.json" isDirectory:NO relativeToURL:groupURL]];
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    item.attachments = @[attachment];
    
    [context completeRequestReturningItems:@[item] completionHandler:nil];
}



@end
