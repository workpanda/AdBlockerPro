//
//  AppData.h
//  Sqouter
//
//  Created by Passion on 4/30/15.
//  Copyright (c) 2015 Passion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface AppData : NSObject

+ (AppData*) sharedData;
@property (nonatomic, retain) NSMutableArray* arrBlockList;


@property (nonatomic) BOOL bShowedGuide;
@property (nonatomic) BOOL bPremiumMembership;

- (void) createBlockListArray;
- (NSString* _Nonnull) getJSONInfo;
- (void) blockList: (NSInteger) nIdx on: (BOOL) bOn;
- (void) blockItem: (NSInteger) nListIndex itemIdx: (NSInteger) nItemIndex on: (BOOL) bOn;

@end
