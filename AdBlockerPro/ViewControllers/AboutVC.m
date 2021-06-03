//
//  AboutVC.m
//  AdBlockerPro
//
//  Created by Passion on 10/20/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "AboutVC.h"
#import "AboutCell.h"
#import "Constant.h"
#import "Appirater.h"

#import <MessageUI/MessageUI.h>

@interface AboutVC ()<UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTop;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end

@implementation AboutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"About Screen";
    
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
    self.lblTop.text  = NSLocalizedString(@"About & Help", @"");
    self.lblDescription.text = NSLocalizedString(@"Popular Adblocker with the goal to remove all in your Safari Browser!", @"");
    
}

- (IBAction)backPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Data Source and delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"AboutCell";
    
    NSUInteger nRow = indexPath.row;
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    AboutCell* cellAbout = (AboutCell*) cell;
    
    [cellAbout initCell];
    
    switch (nRow)
    {
        case 0:
            cellAbout.ivIcon.image = [UIImage imageNamed:@"icon_feedback"];
            cellAbout.lblTitle.text = NSLocalizedString(@"Send Feedback", @"");
            break;
        case 1:
            cellAbout.ivIcon.image = [UIImage imageNamed:@"icon_rate"];
            cellAbout.lblTitle.text = NSLocalizedString(@"Rate us", @"");
            break;
        case 2:
            cellAbout.ivIcon.image = [UIImage imageNamed:@"icon_tutor"];
            cellAbout.lblTitle.text = NSLocalizedString(@"Tutorial", @"");
            break;

        
        default:
        break;
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1f];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [self sendFeedback];
            break;
        case 1:
            [self rateUs];

            break;
        case 2:
            [self performSegueWithIdentifier:@"showguide" sender:nil];
            break;

        
        default:
        break;
    }
}

#pragma mark - Utility
- (void) sendFeedback
{
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat:@"Feedback & Feature Request"];
    
    // Email Content
    
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"adblockone@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:@"" isHTML:YES];
    [mc setToRecipients:toRecipents];
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) rateUs
{
    [Appirater rateApp];

    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_STORE_URL]];
}

#pragma mark - Mail Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
            NSLog(@"Mail cancelled");
            break;
            
        }
        case MFMailComposeResultSaved:
        {
            NSLog(@"Mail saved");
            break;
            
        }
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail sent");
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"AdBlocker Pro" message:@"Successfully sent feedback" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            
            break;
        }
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            
        }
        default:
        break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
