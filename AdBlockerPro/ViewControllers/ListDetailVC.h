//
//  ListDetailVC.h
//  AdBlockerPro
//
//  Created by Passion on 10/16/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//



@interface ListDetailVC : BaseVC<UITableViewDelegate, UITableViewDataSource>

#pragma mark - Sub Views
@property (weak, nonatomic) IBOutlet UITableView *tableBlockItems;
@property (weak, nonatomic) IBOutlet UILabel *lblListName;

#pragma mark - Properties
@property (nonatomic, retain) NSMutableDictionary* dicBlockListInfo;
@property (nonatomic) NSInteger nListIdx;


@end
