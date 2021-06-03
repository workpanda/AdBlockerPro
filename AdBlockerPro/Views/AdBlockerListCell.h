//
//  AdBlockerListCell.h
//  AdBlockerPro
//
//  Created by Passion on 10/13/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdBlockerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblListName;
@property (weak, nonatomic) IBOutlet UILabel *lblBlockCnt;
@property (weak, nonatomic) IBOutlet UISwitch *switchBlocker;

@property (weak, nonatomic) IBOutlet UILabel *viewGo;

-(void)hiddenGoIcon;
- (void) initWithInfo: (NSMutableDictionary*) dicListInfo;

@end
