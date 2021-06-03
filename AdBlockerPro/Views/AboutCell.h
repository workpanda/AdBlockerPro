//
//  AboutCell.h
//  AdBlockerPro
//
//  Created by Passion on 10/21/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (void) initCell;

@end
