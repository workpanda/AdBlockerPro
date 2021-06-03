//
//  ListDetailVC.m
//  AdBlockerPro
//
//  Created by Passion on 10/16/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "Constant.h"
#import "ListDetailVC.h"
#import "AdBlockerItemCell.h"
#import "AdBlockManager.h"
#import "JDStatusBarNotification.h"
#import "MBProgressHUD.h"

@interface ListDetailVC ()<UISearchBarDelegate>
{
    NSMutableArray* arrSearchResult;
    NSMutableArray* arrTotalItems;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSInteger nTempIdx;
@property (nonatomic) BOOL bTempOn;


@end

@implementation ListDetailVC

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"Category Detail Screen";
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:kBlockListChanged object:nil];
    
    [self checkListEnabled];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Utility
- (void) checkListEnabled
{
    if (![[self.dicBlockListInfo valueForKey:kBlockListEnabled] boolValue])
    {
        [JDStatusBarNotification showWithStatus:NSLocalizedString(@"This package is disabled.", @"") dismissAfter:1.f styleName:JDStatusBarStyleError];
    }
}

- (void) initData
{
    self.dicBlockListInfo = [[AppData sharedData].arrBlockList objectAtIndex:self.nListIdx];
    
    arrTotalItems = [NSMutableArray array];
    arrSearchResult = [NSMutableArray array];

    arrTotalItems = [self.dicBlockListInfo valueForKey:kBlockListValue];
    
    NSLog(@"%@",arrTotalItems);
    
    [self getSearchResult: self.searchBar.text];
}

- (void) initUI
{
    arrTotalItems = [NSMutableArray array];
    arrSearchResult = [NSMutableArray array];
    
    
    
    if (self.dicBlockListInfo == nil)
    {
        return;
    }
    
    self.lblListName.text = NSLocalizedString([self.dicBlockListInfo valueForKey:kBlockListName], @"");
    self.searchBar.placeholder = NSLocalizedString(@"Search", @"");

    arrTotalItems = [self.dicBlockListInfo valueForKey:kBlockListValue];
    
     NSLog(@"%@",arrTotalItems);
    
    arrSearchResult = [NSMutableArray arrayWithArray:arrTotalItems];
    
}



#pragma mark - User Interaction
- (IBAction)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSearchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AdBlockerItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSMutableDictionary* dicItemInfo = [arrSearchResult objectAtIndex:indexPath.row];
    
    NSLog(@"Item Info: %@", dicItemInfo);
    
    
    AdBlockerItemCell* cellItem = (AdBlockerItemCell*)cell;
    
    [cellItem initCellWithInfo:dicItemInfo withListIdx:self.nListIdx];
    
    
    cellItem.switchTurn.enabled = [[self.dicBlockListInfo valueForKey:kBlockListEnabled] boolValue];
    [cellItem.switchTurn setOn:[[dicItemInfo valueForKey:kBlockItemEnabled] boolValue]];
    
    [cellItem.switchTurn addTarget:self action:@selector(onBlockItemSwitchHasChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    cellItem.switchTurn.tag = [[dicItemInfo valueForKey:kBlockItemIndex] intValue];
    
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    
    return YES;
}

// hide search bar's cancel button when not editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    arrSearchResult = [NSMutableArray arrayWithArray:arrTotalItems];
    
    [self.tableBlockItems reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@", searchText);
    
    [self getSearchResult: searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - Utility
- (void) getSearchResult: (NSString*) strSearchText
{
    if (strSearchText.length == 0)
    {
        arrSearchResult = [NSMutableArray arrayWithArray:arrTotalItems];
        [self.tableBlockItems reloadData];
        return;
    }
    
    
    NSMutableArray* arrNewSearchResult = [NSMutableArray array];
    
    for (int i = 0; i < arrTotalItems.count; i++)
    {
        NSMutableDictionary* dicItemInfo = [arrTotalItems[i] valueForKey:kBlockItemValue];
        
        NSMutableDictionary* dicTrigger = [dicItemInfo valueForKey:@"trigger"];
        
        NSString* strUrlFilter = [dicTrigger valueForKey:@"url-filter"];
        
        strUrlFilter = [self urlFilterString:strUrlFilter filterType:self.nListIdx];
        
        if ([strUrlFilter containsString:strSearchText])
        {
            [arrNewSearchResult addObject:arrTotalItems[i]];
        }
    }
    
    arrSearchResult = [NSMutableArray arrayWithArray:arrNewSearchResult];
    
    [self.tableBlockItems reloadData];
}

- (void)onBlockItemSwitchHasChanged:(UISwitch *)switchTurn
{
    BOOL bOn = switchTurn.on;
    
    NSInteger nItemIdx = switchTurn.tag;
    
    self.nTempIdx = nItemIdx;
    self.bTempOn = bOn;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:0.3f];

    [self performSelector:@selector(updateBlockItem) withObject:nil afterDelay:0.1f];
    
}

- (void) hideProgressHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) updateBlockItem
{
    [[AppData sharedData] blockItem:self.nListIdx itemIdx:self.nTempIdx on:self.bTempOn];
    
}

- (NSString*) urlFilterString: (NSString*) originUrlFilter filterType: (NSInteger) nListType
{
    NSString* strResult = @"";
    
    if ([strResult containsString:@"https"])
    {
        strResult = [originUrlFilter substringFromIndex:10];
        strResult = [strResult stringByReplacingOccurrencesOfString:@"\\." withString:@"."];
    }
    else
    {
        strResult = originUrlFilter;
        
    }

//    switch (nListType)
//    {
//        case LIST_ADULT:
//            strResult = [originUrlFilter substringFromIndex:10];
//            strResult = [strResult stringByReplacingOccurrencesOfString:@"\\." withString:@"."];
//
//            break;
//            
//        case LIST_MALWARE:
//            strResult = originUrlFilter;
//            break;
//        case LIST_FACEBOOK:
//        {
//            if ([strResult containsString:@"https"])
//            {
//                strResult = [originUrlFilter substringFromIndex:10];
//                strResult = [strResult stringByReplacingOccurrencesOfString:@"\\." withString:@"."];
//            }
//            else
//            {
//                strResult = originUrlFilter;
//
//            }
//            break;
//        }
//        
//        default:
//            break;
//    }
    
    
    return strResult;
}


@end
