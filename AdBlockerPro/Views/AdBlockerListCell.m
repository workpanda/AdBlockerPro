//
//  AdBlockerListCell.m
//  AdBlockerPro
//
//  Created by Passion on 10/13/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "AdBlockerListCell.h"
#import "Constant.h"
#import "AdblockManager.h"

@implementation AdBlockerListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initWithInfo: (NSMutableDictionary*) dicListInfo
{
    self.ivIcon.layer.cornerRadius = 6;
    self.ivIcon.layer.masksToBounds = YES;
    self.ivIcon.userInteractionEnabled=YES;

    self.lblListName.text = NSLocalizedString([dicListInfo valueForKey:kBlockListName], @"");
    self.lblBlockCnt.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)((NSMutableArray*)[dicListInfo valueForKey:kBlockListValue]).count, NSLocalizedString(@"rules", @"")];
    
    self.switchBlocker.enabled = [AdBlockManager sharedInstance].enabled;
    
    [self.switchBlocker setOn:[[dicListInfo valueForKey:kBlockListEnabled] boolValue]];
}

-(void)hiddenGoIcon{
    self.viewGo.hidden = YES;
}

-(void)layoutSubviews{
    self.viewMain.frame = self.contentView.frame;
    
}

@end
