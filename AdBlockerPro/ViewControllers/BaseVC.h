//
//  BaseVC.h
//  AdBlockerPro
//
//  Created by Passion on 9/30/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

@interface BaseVC : GAITrackedViewController

- (void) sendEventWithCategory: (NSString*) category action: (NSString*) action label: (NSString*) lable value: (NSNumber *) value;
@end
