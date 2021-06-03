//
//  Constant.h
//  Sqouter
//
//  Created by Passion on 4/24/15.
//  Copyright (c) 2015 Passion. All rights reserved.
//

#ifndef Sqouter_Constant_h
#define Sqouter_Constant_h

//https://itunes.apple.com/us/app/adblock-pro-no-ads-no-tracking/id1051244220?ls=1&mt=8

#pragma mark - Segues
#define kShowLoginSegue @"showLogin"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kShowedGuide            @"showedguide"
#define kPremiumMembership      @"premiummembership"

#define COLOR_TAB [UIColor colorWithRed:10/255.0f green:48/255.0f blue:5/255.0f alpha:1.0f]
#define COLOR_BROWN_BG [UIColor colorWithRed:206.f/255.0f green:212.f/255.0f blue:170.f/255.0f alpha:1.0f]


#define RUN_ASYNC_METHOD(_Inner) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{_Inner});


#pragma mark -  App Setting
#define kBlockListStatusArray @"blockliststatusarray"


#pragma mark - Key Names
#define kBlockListName          @"blocklistname"
#define kBlockListEnabled       @"blocklistenabled"
#define kBlockListValue         @"blocklistvalue"
#define kBlockItemEnabled       @"blockitemenabled"
#define kBlockItemIndex         @"blockitemindex"
#define kBlockItemValue         @"blockitemvalue"
#define kBlockListChanged       @"blocklistchanged"

#pragma mark - List Names
#define LIST_ADS                0
#define LIST_YOUTUBE_ADS        1
#define LIST_TRACKER            2
#define LIST_FACEBOOK           3
#define LIST_TWITTER            4
#define LIST_OTHER              5
#define LIST_MALWARE            6
#define LIST_ADULT              7
#define LIST_WEB_FONT           8

#pragma mark - Constants
#define APP_STORE_URL   @"https://itunes.apple.com/us/app/adblock-pro-no-ads-no-tracking/id1051244220?ls=1&mt=8"
#define GA_TRACKING_ID  @"UA-68915031-1"
#define kAllowTracking  @"allowTracking"
#define kRate @"rating"
#define kAppStoreID @"1051244220"

#define kUpgradeMembership  @"com.jimmylab.AdBlockerPro.premium"

#define TRIGGER_VAL     @"trigger"
#define URL_VAL         @"url-filter"

#define kGroupName      @"group.com.adblockpro.sharedgroup"

#endif
