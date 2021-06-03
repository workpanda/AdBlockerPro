//
//  MainVC.m
//  AdBlockerPro
//
//  Created by Passion on 9/30/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "MainVC.h"
#import "AdBlockerListCell.h"
#import "AdBlockManager.h"
#import "ListDetailVC.h"
#import "Appirater.h"
#import "EBPurchase.h"
#import "UpgradedCell.h"


#define ALERT_IAP       100
#define ALERT_INFORM    1000

#import <QuartzCore/QuartzCore.h>

@interface MainVC ()<UITableViewDataSource, UITableViewDelegate, EBPurchaseDelegate, MBProgressHUDDelegate, UIAlertViewDelegate>
{
    CAGradientLayer *maskLayer;
}

#pragma mark - Sub Views

@property (nonatomic, strong) UISwitch* switchTrack;
@property (weak, nonatomic) IBOutlet UISwitch *switchTurn;

@property (weak, nonatomic) IBOutlet UIView *viewListContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableContent;

#pragma mark - Properties
@property  (nonatomic, retain) EBPurchase* ebPurchase;
@property (nonatomic) BOOL bPurchaseSuccess;

@property (nonatomic) NSInteger nTempIdx;
@property (nonatomic) BOOL bTempOn;

@end

@implementation MainVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"Main Category Screen";
    [self initUI];
    
    
    //EbPurchase
    self.ebPurchase = [[EBPurchase alloc] init];
    self.ebPurchase.delegate = self;
    self.ebPurchase.validProduct = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kBlockListChanged object:nil];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setGradientMask:self.viewListContainer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Initialization
- (void) initUI
{
    //Init switchTurn
    self.switchTurn.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [self.switchTurn setOn:[AdBlockManager sharedInstance].enabled];

    [self.switchTurn addTarget:self action:@selector(onSwitchHasChanged:) forControlEvents:UIControlEventValueChanged];

}

- (void) refreshData
{
    [self.tableContent reloadData];
}


- (void) setGradientMask: (UIView*) view
{
    if (!maskLayer)
    {
        maskLayer = [CAGradientLayer layer];
        
        CGColorRef outerColor = [UIColor colorWithRed:22.f / 255.f green:35.f / 255.f blue:37.f / 255.f alpha:1.0f].CGColor;
        CGColorRef innerColor = [UIColor colorWithRed:22.f / 255.f green:35.f / 255.f blue:37.f / 255.f alpha:0.0f].CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                            (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.05],
                               [NSNumber numberWithFloat:0.95],
                               [NSNumber numberWithFloat:1.0], nil];
        
        maskLayer.bounds = CGRectMake(0, 0,
                                      view.frame.size.width,
                                      view.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        
        [view.layer addSublayer:maskLayer];
    }
}



#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nRowCnt = 0;
    
    switch (section)
    {
        case 0:
            nRowCnt = 2;
            
            break;
        case 1:
            nRowCnt = 1;
            
            break;
        case 2:
            nRowCnt = 3;
            
            break;
        case 3:
            nRowCnt = 2;
            
            break;
        case 4:
            nRowCnt = 1;
            
            break;
        case 5:
            nRowCnt = 1;
            
            break;
        case 6:
            nRowCnt = 1;
            
            break;
        case 7:
            nRowCnt = 1;
            
        default:
            break;
    }
    
    return nRowCnt;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* strSectionHeader = @"";
    
    switch (section)
    {
        case 0:
            strSectionHeader = NSLocalizedString(@"ADS", @"");
            
            break;
        case 1:
            strSectionHeader = NSLocalizedString(@"PRIVACY", @"");
            
            break;
        case 2:
            strSectionHeader = NSLocalizedString(@"SOCIAL TRACKER", @"");
            
            break;
        case 3:
            strSectionHeader = NSLocalizedString(@"MALWARE & ADULT", @"");
            
            break;
        case 4:
            strSectionHeader = NSLocalizedString(@"MULTIPURPOSE & BANDWIDTH", @"");
            
            break;
        case 5:
            strSectionHeader = @"";
            
            break;
        case 6:
            strSectionHeader = @"";
            
            break;
        case 7:
            strSectionHeader = @"";
            
            break;

            
        default:
            break;
    }
    
    return strSectionHeader;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString* strSectionFooter = 0;
    
    switch (section)
    {
        case 0:
            strSectionFooter = @"";
            
            break;
        case 1:
            strSectionFooter = @"";
            
            break;
        case 2:
            strSectionFooter = @"";
            
            break;
        case 3:
            strSectionFooter = @"";
            
            break;
        case 4:
            strSectionFooter = @"";
            
            break;
        case 5:
            strSectionFooter = @"";
            
            break;
        case 6:
            strSectionFooter = @"";
            
            break;
            
        default:
            break;
    }
    
    return strSectionFooter;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"";
    
    NSUInteger nRow = indexPath.row;
    NSUInteger nSection = indexPath.section;
    
    NSInteger nIdx = 0;
    for (int i = 0; i < nSection; i++)
    {
        nIdx += [self.tableContent numberOfRowsInSection:i];
    }
    
    nIdx += nRow;
    
    UITableViewCell *cell = nil;
    
    switch (nSection)
    {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
            CellIdentifier = @"AdBlockerListCell";
            break;
            

        case 6: //Upgrade
        {
            if ([AppData sharedData].bPremiumMembership)
            {
                CellIdentifier = @"UpgradedCell";
            }
            else
            {
                CellIdentifier = @"UITableViewCell";
            }
            
            break;
        }
        case 5: //Happy
        case 7: //About
            CellIdentifier = @"UITableViewCell";
            break;
            
            
        default:
            break;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (nSection < 5)
    {
        if ([CellIdentifier isEqualToString:@"AdBlockerListCell"])
        {
            AdBlockerListCell* cellListInfo = (AdBlockerListCell*) cell;
            
            if (nIdx < [AppData sharedData].arrBlockList.count)
            {
                NSMutableDictionary* dicListInfo = [AppData sharedData].arrBlockList[nIdx];
                
                if (dicListInfo)
                {
                    [cellListInfo initWithInfo:[NSMutableDictionary dictionaryWithDictionary:dicListInfo]];
                }
                
            }
            
            [cellListInfo.switchBlocker addTarget:self action:@selector(onBlockerSwitchHasChanged:) forControlEvents:UIControlEventValueChanged];
            cellListInfo.switchBlocker.tag = nIdx;
            
            if (nIdx == 2)
            {
                self.switchTrack = cellListInfo.switchBlocker;
            }
            
            NSString* strImageName = @"";
            switch (nIdx)
            {
                case 0:
                    strImageName = @"icon_ads";
                    break;
                case 1:
                    strImageName = @"icon_youtube";
                    break;
                case 2:
                    strImageName = @"icon_tracker";
                    break;
                case 3:
                    strImageName = @"icon_fb";
                    break;
                case 4:
                    strImageName = @"icon_twitter";
                    break;
                case 5:
                    strImageName = @"icon_share";
                    break;
                case 6:
                    strImageName = @"icon_bug";
                    break;
                case 7:
                    strImageName = @"icon_adult";
                    break;
                case 8:
                    strImageName = @"icon_font";
                    break;
                default:
                    break;
            }
            
            cellListInfo.ivIcon.image = [UIImage imageNamed:strImageName];
        }
    }
    switch (nSection)
    {
        case 5:
            cell.textLabel.text = NSLocalizedString(@"Happy with AdBlock Pro?", @"");
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
        case 7:
            cell.textLabel.text = NSLocalizedString(@"About & Help", @"");
            cell.textLabel.textColor = [UIColor whiteColor];
            break;
            
        case 6:
            
            if (![AppData sharedData].bPremiumMembership)
            {
                cell.textLabel.text = NSLocalizedString(@"Upgrade to enable Tracker blockers", @"");
            }
            else
            {
                UpgradedCell* cellUpgrade = (UpgradedCell*) cell;
                cellUpgrade.lblTitle.text = NSLocalizedString(@"Premium activated (all blocker + updates)", @"");
            }
            
            cell.textLabel.textColor = ([AppData sharedData].bPremiumMembership) ? [UIColor colorWithWhite:1.f alpha:0.7f] :[UIColor whiteColor];
            break;
        default:
            break;
    }
    
    
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1f];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(nSection == 3){
        [((AdBlockerListCell*)cell) hiddenGoIcon];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 3){
        return;
    }
    
    if (indexPath.section < 5)
    {
        NSUInteger nRow = indexPath.row;
        NSUInteger nSection = indexPath.section;
        
        NSInteger nIdx = 0;
        for (int i = 0; i < nSection; i++)
        {
            nIdx += [self.tableContent numberOfRowsInSection:i];
        }
        
        nIdx += nRow;
        
        [self performSegueWithIdentifier: @"showListInfo" sender: [NSNumber numberWithInt:nIdx]];
        
        return;
    }
    
    switch (indexPath.section)
    {
        case 5:
            [Appirater showAlertWithoutLater];
            break;
        case 7:
            [self performSegueWithIdentifier:@"aboutSegue" sender:nil];
            break;
        case 6:
            if (![AppData sharedData].bPremiumMembership)
            {
                [self upgradeMembership];
            }
            
            
            
        default:
            break;
    }
}

#pragma mark - User Interaction
- (void)onSwitchHasChanged:(UISwitch *)switchTurn
{
    BOOL bOn = switchTurn.on;
    
    [[AdBlockManager sharedInstance] setEnabled:bOn reload:YES];
    
    [self.tableContent reloadData];
}

- (void)onBlockerSwitchHasChanged:(UISwitch *)switchTurn
{
    BOOL bOn = switchTurn.on;
    
    NSInteger nIdx = switchTurn.tag;


    
    if (nIdx == 2) //Block Tracker
    {
        if (![AppData sharedData].bPremiumMembership)
        {
            [self upgradeMembership];
            
            [switchTurn setOn:NO];
            
            return;
        }

    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:2.f];
    
    self.nTempIdx = nIdx;
    self.bTempOn = bOn;
    
    
    [self performSelector:@selector(updateBlockList) withObject:nil afterDelay:0.1f];
}

#pragma mark - Utility
- (void) updateBlockList
{
    [[AppData sharedData] blockList:self.nTempIdx on:self.bTempOn];
}

- (void) hideProgressHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) upgradeMembership
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upgrade membership", @"")  message:NSLocalizedString(@"Are you sure to upgrade to the Premium version to enable Tracker blockers?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"No, Thanks", @"") otherButtonTitles:[NSString stringWithFormat:@"%@ $2.99", NSLocalizedString(@"Upgrade to Premium Version:", @"")], NSLocalizedString(@"Restore Purchase", @""), nil];
    alert.tag = ALERT_IAP;
    
    [alert show];
}

- (void) purchaseMembership
{
    self.bPurchaseSuccess = NO;
    
    if (self.ebPurchase.validProduct == nil)
    {
        NSLog(@"Purchase");
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.ebPurchase requestProduct:kUpgradeMembership];
    }
    else
    {
        self.ebPurchase.validProduct = nil;
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        [self.ebPurchase requestProduct:kUpgradeMembership];
        
    }
}

- (void) restoreMembership
{
    self.bPurchaseSuccess = NO;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.ebPurchase restorePurchase];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showListInfo"])
    {
        ListDetailVC *destViewController = segue.destinationViewController;
        NSMutableDictionary* dicListInfo = [NSMutableDictionary dictionaryWithDictionary:[AppData sharedData].arrBlockList[[sender intValue]]];
        
        destViewController.dicBlockListInfo = dicListInfo;
        destViewController.nListIdx = [sender intValue];
    }
    
}

#pragma mark - EBPurchaseDelegate Methods

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    NSLog(@"ViewController requestedProduct");
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if (productPrice != nil)
    {
        // Product is available, so update button title with price.
        NSLog(@"Product exist");
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.ebPurchase purchaseProduct:self.ebPurchase.validProduct];
        
    }
    else
    {
        // Product is NOT available in the App Store, so notify user.
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp restored:(bool)isRestore identifier:(NSString*)productId receipt:(NSData*)transactionReceipt
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"ViewController successfulPurchase");
    
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (self.bPurchaseSuccess)
    {
        return;
    }
    else
        self.bPurchaseSuccess = YES;
    
    if (!isRestore)
    {
        NSLog(@"Purchase finished");
    }
    
//    NSString * strReceipt = [transactionReceipt base64EncodedStringWithOptions:0];
//    NSLog(@"TransactionReceipt : %@", strReceipt);
    
    [AppData sharedData].bPremiumMembership = YES;
    
    if (self.switchTrack) {
        [self.switchTrack setOn:YES];

        [self onBlockerSwitchHasChanged:self.switchTrack];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""  message:NSLocalizedString(@"Congratulations all Blocker + automatic updates are activated!", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     
        
        [alert show];
        
    }
    
  
    
    
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"ViewController failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
    
}

-(void) incompleteRestore:(EBPurchase*)ebp
{
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should
    // restore their purchase.
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
    
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage
{
    NSLog(@"ViewController failedRestore");
    
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    // Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index: %d", buttonIndex);
    
    switch (alertView.tag) {
        case ALERT_INFORM:
        {
            if (buttonIndex == 1)
            {
                [self upgradeMembership];
            }
            break;
        }
            
        case ALERT_IAP:
        {
            switch (buttonIndex)
            {
                case 1: //Upgrade
                    [self purchaseMembership];
                    break;
                case 2: //Restore
                    [self restoreMembership];
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
            
        default:
        {
            break;
        }
    }
    
    

}


@end
