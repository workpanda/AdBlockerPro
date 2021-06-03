//
//  AboutCell.m
//  AdBlockerPro
//
//  Created by Passion on 10/21/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "AboutCell.h"

@implementation AboutCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initCell
{
    self.ivIcon.layer.cornerRadius = 6;
    self.ivIcon.layer.masksToBounds = YES;
    self.ivIcon.userInteractionEnabled=YES;

}

@end
