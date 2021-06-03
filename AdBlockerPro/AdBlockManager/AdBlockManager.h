//
//  AdBlockManager.h
//  AdBlockerPro
//
//  Created by Passion on 10/12/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdBlockManager : NSObject

#pragma mark - Properties
@property (nonatomic) BOOL enabled;
//@property (nonatomic) BOOL acceptableAdsEnabled;
@property (nonatomic) BOOL activated;
@property (nonatomic) BOOL reloading;



#pragma mark - Methods
+ (AdBlockManager* _Nonnull ) sharedInstance;

- (void)setEnabled:(BOOL)enabled reload:(BOOL)reload;
- (void)reloadContentBlockerWithCompletion:(void(^__nullable)(NSError * __nullable error))completion;
- (void)checkActivatedFlag;

@end
