//
//  AdBlockerItemCell.m
//  AdBlockerPro
//
//  Created by Passion on 10/16/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "AdBlockerItemCell.h"
#import "Constant.h"



#define COMMENT_ABORT_LOADING_RESOURCE(_element)       [NSString stringWithFormat: @"Abort loading resources of any type where the resource's URL matches the pattern: %@", _element]
#define COMMENT_HIDE_PAGE_ELEMENTS(_element)      [NSString stringWithFormat: @"Hide page elements with CSS selector \"%@\" on a page with URL matching the pattern: .*", _element]
#define COMMENT_ABORT_THIRD_PARTY_SCRIPT(_element)    [NSString stringWithFormat: @"Abort loading third-party resources (script) where the resources's URL matches the pattern: %@", _element]
#define COMMENT_ABORT_THIRD_PARTY_ALL(_element)    [NSString stringWithFormat: @"Abort loading third-party resources  where the resources's URL matches the pattern: %@", _element]



@implementation AdBlockerItemCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initCellWithInfo: (NSMutableDictionary*) dicItemInfo withListIdx: (NSInteger) nIdx
{
    NSMutableDictionary* dicItemVal = [dicItemInfo valueForKey:kBlockItemValue];
    NSMutableDictionary* dicTriggerVal = [dicItemVal valueForKey:@"trigger"];
    NSMutableDictionary* dicAction = [dicItemVal valueForKey:@"action"];
    
    
    NSString* urlItemName = [self urlStandard:[self itemNameWithAction:dicAction trigger:dicTriggerVal idx:nIdx]];
    
    self.lblItemName.text = urlItemName;
    
    
    NSString* urlDescription = [self urlStandard:[self descriptionWithTrigger:dicTriggerVal action:dicAction idx:nIdx]];
    self.lblItemDescription.text = urlDescription;

    
    
    
}

- (NSString*) itemNameWithAction: (NSMutableDictionary*) dicAction trigger: (NSMutableDictionary*) dicTrigger idx: (NSInteger) nIdx
{
    if (!dicAction) return @"";
    
    NSString* strResult = @"";
    
    NSString* strActionType = [dicAction valueForKey:@"type"];
    
    if ([strActionType isEqualToString:@"css-display-none"])
    {
        strResult = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Hide", @""), [dicAction valueForKey:@"selector"]];
    }
    else if ([strActionType isEqualToString:@"block"])
    {
        NSString* strItemName = [dicTrigger valueForKey:@"url-filter"];
        
        if ([strItemName containsString:@"http"])
        {
            strItemName = [strItemName substringFromIndex:10];
            strItemName = [strItemName stringByReplacingOccurrencesOfString:@"\\." withString:@"."];
        }
        if ([strItemName containsString:@"&amp"])
        {
            strItemName = [strItemName substringFromIndex:10];
            strItemName = [strItemName stringByReplacingOccurrencesOfString:@"&amp" withString:@"&"];
        }

        strResult = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Block", @""),strItemName];
    }
    
    return strResult;
}

- (NSString*) descriptionWithTrigger: (NSMutableDictionary*) dicTrigger action: (NSMutableDictionary*) dicAction idx: (NSInteger) nIdx
{
    if (!dicTrigger) return @"";
    if (!dicAction) return @"";
    
    NSString* strPattern = @"";
    
    NSString* strActionType = [dicAction valueForKey:@"type"];

    strPattern = [dicTrigger valueForKey:@"url-filter"];
    strPattern = [strPattern substringFromIndex:1];
    
    NSString* strDescription = @"";

    if ([strActionType isEqualToString:@"css-display-none"])
    {
        strDescription = COMMENT_HIDE_PAGE_ELEMENTS([dicAction valueForKey:@"selector"]);
    }
    else if ([dicTrigger valueForKey:@"load-type"])
    {
        if ([dicTrigger valueForKey:@"resource-type"])
        {
            BOOL bScriptOnly = NO;
            NSMutableArray* arrResourceType = [dicTrigger valueForKey:@"resource-type"];
            
            if (arrResourceType.count == 1)
            {
                if ([arrResourceType[0] isEqualToString:@"script"])
                {
                    bScriptOnly = YES;
                }
            }
            
            strDescription = (bScriptOnly) ? COMMENT_ABORT_THIRD_PARTY_SCRIPT(strPattern): COMMENT_ABORT_THIRD_PARTY_ALL(strPattern);
        }
        else
        {
            strDescription = COMMENT_ABORT_THIRD_PARTY_ALL(strPattern);
        }
        
    }
    else if ([dicTrigger valueForKey:@"resource-type"])
    {
        strDescription = COMMENT_ABORT_LOADING_RESOURCE(strPattern);
    }
    else
    {
        strDescription = COMMENT_ABORT_LOADING_RESOURCE(strPattern);
    }
    
    return strDescription;
}

-(void)layoutSubviews {
    self.viewContainer.frame = self.contentView.frame;
}

-(NSString*)urlStandard:(NSString*)originalUrl {
    NSString* strResult = @"";
    strResult = [originalUrl stringByReplacingOccurrencesOfString:@"\\."
                                                       withString:@"."];
    return strResult;
}

@end
