//
//  NewGuideVC.m
//  AdBlockerPro
//
//  Created by Passion on 10/27/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "NewGuideVC.h"

@interface NewGuideVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblOpenSetting;
@property (weak, nonatomic) IBOutlet UILabel *lblEnableBlocker;
@property (weak, nonatomic) IBOutlet UILabel *lblTapSafari;
@property (weak, nonatomic) IBOutlet UILabel *lblTapCB;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UILabel *lblSteps;

@end

@implementation NewGuideVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility
- (void) initUI
{
    self.lblSteps.text = NSLocalizedString(@"First Steps:", @"");
    self.lblOpenSetting.text = NSLocalizedString(@"Open Settings App", @"");
    self.lblTapSafari.text = NSLocalizedString(@"Tap Safari", @"");
    self.lblTapCB.text = NSLocalizedString(@"Then Content Blockers", @"");
    self.lblEnableBlocker.text = NSLocalizedString(@"Enable AdBlock Pro", @"");
    
    [self.btnNext setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
}

#pragma mark - User Interaction
- (IBAction)openSettingsApp:(id)sender
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@com.jimmylab.AdBlockerPro", UIApplicationOpenSettingsURLString]]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (IBAction)nextClicked:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"AdBlock Pro" message:NSLocalizedString(@"Finished all steps to activate AdBlock Pro?", @"")  delegate:self cancelButtonTitle:NSLocalizedString(@"Not yet", @"") otherButtonTitles:NSLocalizedString(@"Done", @""), nil];
    
    [alert show];
}

#pragma mark - UIAlertView Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [AppData sharedData].bShowedGuide = YES;
        
        [self performSegueWithIdentifier:@"tomainseguefromnew" sender:nil];
    }
}

@end
