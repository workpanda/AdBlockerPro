//
//  AppData.m
//  Sqouter
//
//  Created by Passion on 4/30/15.
//  Copyright (c) 2015 Passion. All rights reserved.
//

#import "AppData.h"
#import "Constant.h"
#import "JSON.h"
#import "AdBlockManager.h"

static AppData* sharedInstance;
@implementation AppData


#pragma mark - Initialization
+ (AppData*) sharedData
{
    if (sharedInstance == nil) {
        sharedInstance = [[AppData alloc] init];
    }
    
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

#pragma mark - Getter and Setter

- (void) setBShowedGuide:(BOOL)bShowedGuide
{
    [[NSUserDefaults standardUserDefaults] setBool:bShowedGuide forKey:kShowedGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) bShowedGuide
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowedGuide];
}

- (void) setBPremiumMembership:(BOOL)bPremiumMembership
{
    [[NSUserDefaults standardUserDefaults] setBool:bPremiumMembership forKey:kPremiumMembership];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) bPremiumMembership
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPremiumMembership];
}



#pragma mark - Utility
- (BOOL) writeBlockListToFile
{
    NSString* strBlockList = [self getJSONInfo];
    
    
    NSURL *groupURL = [[NSFileManager defaultManager]
                       containerURLForSecurityApplicationGroupIdentifier:
                       kGroupName];
    
    NSLog(@"group path: %@", groupURL.path);
    
    [[NSFileManager defaultManager] changeCurrentDirectoryPath:groupURL.path];
    
    NSLog(@"%@", [NSFileManager defaultManager].currentDirectoryPath);
    
    NSString* fileName = @"blockerList.json";
    
    NSData* strContent = [strBlockList dataUsingEncoding:NSUTF8StringEncoding];
    BOOL bSuccess = [[NSFileManager defaultManager] createFileAtPath:fileName contents:strContent attributes:nil];
    
    if (!bSuccess)
    {
        // Handle error here
        NSLog(@"Error in writeBlockListToFile:");
    }
    else
    {
        [[AdBlockManager sharedInstance] reloadContentBlockerWithCompletion:^(NSError * _Nullable error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishLoading" object:error];
        }];
    }
    
    return bSuccess;
}

- (NSString*) getJSONInfo
{
    NSString* strResult = @"";
    
    NSMutableArray* arrResult = [NSMutableArray array];
    
    NSMutableArray* arrBlockList = self.arrBlockList;
    for (int i = 0; i < arrBlockList.count; i++)
    {
        NSMutableDictionary* dicListInfo = arrBlockList[i];
        
        if ([[dicListInfo valueForKey:kBlockListEnabled] boolValue])
        {
            NSMutableArray* arrBlockItems = [dicListInfo valueForKey:kBlockListValue];
            
            for (int j = 0; j < arrBlockItems.count; j++)
            {
                NSMutableDictionary* dicItemInfo = arrBlockItems[j];
                
                if ([[dicItemInfo valueForKey:kBlockItemEnabled] boolValue])
                {
                    [arrResult addObject:[dicItemInfo valueForKey:kBlockItemValue]];
                }
            }
        }
    }
    
//    NSLog(@"%@", arrResult);
    
    strResult = [arrResult JSONRepresentation];
    
//    NSLog(@"Result: %@", strResult);
    return strResult;
}


#pragma mark - AdBlockList Related
- (NSMutableArray*) arrBlockList
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kBlockListStatusArray];
}

- (void) setArrBlockList:(NSMutableArray *)arrBlockList
{
    [[NSUserDefaults standardUserDefaults] setValue:arrBlockList forKey:kBlockListStatusArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSelector:@selector(writeBlockListToFile) withObject:nil afterDelay:1.5f];
}

- (void) createBlockListArray
{
    NSMutableArray* arrBlockList = [NSMutableArray array];
    
    //Create total block list
    NSMutableArray* arrOriginBlockList = [NSMutableArray array];
    
    
    //Block ads
    NSString *jsonBlockAds = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockadslist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockAds = (NSMutableArray*)[jsonBlockAds JSONValue];
    
    [arrOriginBlockList addObject:arrOriginBlockAds];
    
    //Block Youtube Ads
    NSString *jsonBlockYoutubeAds = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockyoutubeadslist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockYoutubeAds = (NSMutableArray*)[jsonBlockYoutubeAds JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockYoutubeAds];
    
    //Block Tracker
    NSString *jsonBlockTracker = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blocktrackerlist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockTracker = (NSMutableArray*)[jsonBlockTracker JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockTracker];
    
    //Block facebook
    NSString *jsonBlockFacebook = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockfacebooklist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockFacebook = (NSMutableArray*)[jsonBlockFacebook JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockFacebook];
    
    //Block Twitter
    NSString *jsonBlockTwitter = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blocktwitterlist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockTwitter = (NSMutableArray*)[jsonBlockTwitter JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockTwitter];
    
    //Block Other
    NSString *jsonBlockOther = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockotherlist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockOther = (NSMutableArray*)[jsonBlockOther JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockOther];
    
    //Block Malware
    NSString *jsonBlockMalwareSites = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockmalwaresiteslist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockMalware = (NSMutableArray*)[jsonBlockMalwareSites JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockMalware];
    
    //Block Adult Sites
    NSString *jsonBlockAdultSites = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockadultsiteslist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockAdultSites = (NSMutableArray*)[jsonBlockAdultSites JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockAdultSites];
    
    //Block Web Fonts
    NSString *jsonBlockWebFonts = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"blockwebfontslist" withExtension:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray* arrOriginBlockWebFonts = (NSMutableArray*)[jsonBlockWebFonts JSONValue];
    [arrOriginBlockList addObject:arrOriginBlockWebFonts];
    
    
    for (int i = 0; i < arrOriginBlockList.count; i++)
    {
        NSString* strListName = @"";
        
        switch (i)
        {
            case 0:
                strListName = @"Block Ads";
                break;
            case 1:
                strListName = @"Block Youtube Ads";
                break;
            case 2:
                strListName = @"Block Tracker";
                break;
            case 3:
                strListName = @"Block Facebook";
                break;
            case 4:
                strListName = @"Block Twitter";
                break;
            case 5:
                strListName = @"Block Other";
                break;
            case 6:
                strListName = @"Block Malware Sites";
                break;
            case 7:
                strListName = @"Block Adult Sites";
                break;
            case 8:
                strListName = @"Block Web Fonts";
                break;
                
                
            default:
                break;
        }
        
        NSMutableDictionary* dicListInfo = [NSMutableDictionary dictionary];
        
        [dicListInfo setValue:strListName forKey:kBlockListName];
        [dicListInfo setValue:[NSNumber numberWithBool:(i == 0)] forKey:kBlockListEnabled];
        
        NSMutableArray* arrItemInfo = [NSMutableArray array];
        
        
        int nItemIdx = 0;
        NSMutableArray* arrOriginItems = [arrOriginBlockList objectAtIndex:i];
        for (int j = 0; j < arrOriginItems.count; j++)
        {
            NSMutableDictionary* dicItemInfo = [NSMutableDictionary dictionary];
            
            if (i == 7) //Adult sites
            {
                NSMutableDictionary* dicTempItemInfo = [NSMutableDictionary dictionaryWithDictionary:[arrOriginItems objectAtIndex:j]];
                
                NSMutableDictionary* dicTriggerInfo = [dicTempItemInfo valueForKey:TRIGGER_VAL];
                
                NSString* strUrl = [dicTriggerInfo valueForKey:URL_VAL];
                
                if ([strUrl hasSuffix:@".com"])
                {
                    [dicItemInfo setValue:[NSNumber numberWithBool:YES] forKey:kBlockItemEnabled];
                    [dicItemInfo setValue:[arrOriginItems objectAtIndex:j] forKey:kBlockItemValue];
                    [dicItemInfo setValue:[NSNumber numberWithInt:nItemIdx] forKey:kBlockItemIndex];
                    
                    [arrItemInfo addObject:dicItemInfo];
                    
                    nItemIdx++;
                }
            }
            else
            {
                [dicItemInfo setValue:[NSNumber numberWithBool:YES] forKey:kBlockItemEnabled];
                [dicItemInfo setValue:[arrOriginItems objectAtIndex:j] forKey:kBlockItemValue];
                [dicItemInfo setValue:[NSNumber numberWithInt:nItemIdx] forKey:kBlockItemIndex];
                
                [arrItemInfo addObject:dicItemInfo];
                
                nItemIdx++;
                
            }
            
        }
        
        [dicListInfo setValue:arrItemInfo forKey:kBlockListValue];
        
        
        [arrBlockList addObject:dicListInfo];
    }
    
    if (arrBlockList)
    {
        self.arrBlockList = arrBlockList;
    }
    
    return;
}


#pragma mark - Utility
- (void) blockItem: (NSInteger) nListIndex itemIdx: (NSInteger) nItemIndex on: (BOOL) bOn
{
    NSMutableArray* arrBlockList = [NSMutableArray arrayWithArray:self.arrBlockList];
    
    NSMutableDictionary* dicListInfoSel= [NSMutableDictionary dictionaryWithDictionary:arrBlockList[nListIndex]];
    
    NSMutableArray* arrBlockItems = [NSMutableArray arrayWithArray:[dicListInfoSel valueForKey:kBlockListValue]];
    
    NSMutableDictionary* dicItemInfoSel = [NSMutableDictionary dictionaryWithDictionary:[arrBlockItems objectAtIndex:nItemIndex]];
    
    [dicItemInfoSel setValue:[NSNumber numberWithBool:bOn] forKey:kBlockItemEnabled];
    
    
    [arrBlockItems replaceObjectAtIndex:nItemIndex withObject:dicItemInfoSel];
    [dicListInfoSel setValue:arrBlockItems forKey:kBlockListValue];
    
    [arrBlockList replaceObjectAtIndex:nListIndex withObject:dicListInfoSel];
    
    self.arrBlockList = arrBlockList;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBlockListChanged object:nil];
    //Reload Block List
//    [self performSelector:@selector(reloadContentBlockerWithCompletion:) withObject:nil afterDelay:0.3f];
    
}

- (void) blockList: (NSInteger) nIdx on: (BOOL) bOn
{
    NSMutableArray* arrBlockList = [NSMutableArray arrayWithArray:self.arrBlockList];
    
    NSMutableDictionary* dicListInfoSel= [NSMutableDictionary dictionaryWithDictionary:arrBlockList[nIdx]];
    
    [dicListInfoSel setValue:[NSNumber numberWithBool:bOn] forKey:kBlockListEnabled];
    
    [arrBlockList replaceObjectAtIndex:nIdx withObject:dicListInfoSel];
    
    /*
     * Enable only 1 blocker
     
    if ([AppData sharedData].bPremiumMembership)
    {
        NSMutableDictionary* dicListInfoSel= [NSMutableDictionary dictionaryWithDictionary:arrBlockList[nIdx]];
        
        [dicListInfoSel setValue:[NSNumber numberWithBool:bOn] forKey:kBlockListEnabled];
        
        [arrBlockList replaceObjectAtIndex:nIdx withObject:dicListInfoSel];
    }
    else
    {
        //Should make only one active
        
        for (int i = 0; i < arrBlockList.count; i++)
        {
            NSMutableDictionary* dicListInfoSel= [NSMutableDictionary dictionaryWithDictionary:arrBlockList[i]];
            
            if (i == nIdx)
            {
                [dicListInfoSel setValue:[NSNumber numberWithBool:bOn] forKey:kBlockListEnabled];
            }
            else
            {
                [dicListInfoSel setValue:[NSNumber numberWithBool:NO] forKey:kBlockListEnabled];
            }
            
            [arrBlockList replaceObjectAtIndex:i withObject:dicListInfoSel];
        }
    }
     */
    
    
    self.arrBlockList = arrBlockList;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kBlockListChanged object:nil];
    
//    //Reload Block List
//    [self performSelector:@selector(reloadContentBlockerWithCompletion:) withObject:nil afterDelay:0.3f];
    
}






@end
