//
//  AdBlockManager.m
//  AdBlockerPro
//
//  Created by Passion on 10/12/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "AdBlockManager.h"
#import "Constant.h"
#import "JSON.h"
#import "AppData.h"




@import SafariServices;

static NSString *AdblockProActivated = @"AdblockProActivated";
static NSString *AdblockProEnabled = @"AdblockProEnabled";
//static NSString *AdblockProAcceptableAdsEnabled = @"AdblockProAcceptableAdsEnabled";

@interface AdBlockManager ()

@property (nonatomic, strong) NSUserDefaults *adblockProDetails;
@property (nonatomic, strong) NSString *bundleName;

@end


@implementation AdBlockManager
static AdBlockManager *sharedInstance = nil;

+ (AdBlockManager*) sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[[self class] alloc]init];
    }
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _bundleName = [[[[[NSBundle mainBundle] bundleIdentifier] componentsSeparatedByString:@"."] subarrayWithRange:NSMakeRange(0, 2)] componentsJoinedByString:@"."];
        //I am younger brother of ying
        /*
        NSString *group = [NSString stringWithFormat:@"group.%@.%@", _bundleName, @"AdBlockerPro"];
        */
        
        _adblockProDetails = [[NSUserDefaults alloc] initWithSuiteName:kGroupName];
        
        NSLog(@"Group Name: %@", kGroupName);
        // Ying hope you are doing great.
        [_adblockProDetails registerDefaults:
         @{ AdblockProActivated: @NO,
            AdblockProEnabled: @YES
            }]; //            AdblockProAcceptableAdsEnabled: @YES
        // and he ask if you can transfer the WATI project to me.
        _enabled = [_adblockProDetails boolForKey:AdblockProEnabled];
        // *** and please share your github id, so I can add you as collaborate to this project. and you can commit your update here.
        _activated = [_adblockProDetails boolForKey:AdblockProActivated];
    }
    return self;
}

#pragma mark - Property

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [_adblockProDetails setBool:enabled forKey:AdblockProEnabled];
    [_adblockProDetails synchronize];
}

- (void)setActivated:(BOOL)activated
{
    _activated = activated;
    [_adblockProDetails setBool:activated forKey:AdblockProActivated];
    [_adblockProDetails synchronize];
}

#pragma mark -

- (NSString *)contentBlockerIdentifier
{
    NSLog(@"ContentBlockID: %@", [NSString stringWithFormat:@"%@.AdBlockerPro.AdBlockProSafariExtension", _bundleName]);
    return [NSString stringWithFormat:@"%@.AdBlockerPro.AdBlockProSafariExtension", _bundleName];
}

- (void)setEnabled:(BOOL)enabled reload:(BOOL)reload
{
    self.enabled = enabled;
    
    if (reload) {
        [self reloadContentBlockerWithCompletion:nil];
    }
}


- (void)reloadContentBlockerWithCompletion:(void(^__nullable)(NSError * __nullable error))completion;
{
    __weak __typeof(self) wSelf = self;
    wSelf.reloading = YES;
    [SFContentBlockerManager reloadContentBlockerWithIdentifier:self.contentBlockerIdentifier completionHandler:^(NSError *error) {
        
        if (error)
        {
            NSLog(@"Error in reloadContentBlocker: %@", error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            wSelf.reloading = NO;
            [wSelf checkActivatedFlag];
            if (completion) {
                completion(error);
            }
        });
    }];
}

- (void)checkActivatedFlag
{
    BOOL activated = [_adblockProDetails boolForKey:AdblockProActivated];
    if (self.activated != activated) {
        self.activated = activated;
    }
}



@end
