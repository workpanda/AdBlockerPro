//
//  AdBlockerItemCell.h
//  AdBlockerPro
//
//  Created by Passion on 10/16/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdBlockerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UISwitch *switchTurn;
@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblItemDescription;

- (void) initCellWithInfo: (NSMutableDictionary*) dicItemInfo withListIdx: (NSInteger) nIdx;

@end
