//
//  BaseVC.m
//  AdBlockerPro
//
//  Created by Passion on 9/30/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "BaseVC.h"
#import "GAIDictionaryBuilder.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility
- (void) sendEventWithCategory: (NSString*) category action: (NSString*) action label: (NSString*) lable value: (NSNumber *) value
{
    NSMutableDictionary *event =
    [[GAIDictionaryBuilder createEventWithCategory:category
                                            action:action
                                             label:lable
                                             value:value] build];
    [[GAI sharedInstance].defaultTracker send:event];
    [[GAI sharedInstance] dispatch];
}


@end
