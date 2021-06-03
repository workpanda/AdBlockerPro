//
//  ViewController.m
//  AdBlockerPro
//
//  Created by Passion on 9/29/15.
//  Copyright © 2015 jimmylab. All rights reserved.
//

#import "ViewController.h"
#import "AppData.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

#import "GuideVC.h"
#import "MainVC.h"

#import "AdBlockManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *ivAnimator;
@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkResult:) name:@"finishLoading" object:nil];
    
    //AdBlock
    if (![AppData sharedData].arrBlockList)
    {
        [[AppData sharedData] createBlockListArray];
    }
    else
    {
        if (![AdBlockManager sharedInstance].activated)
        {
            [[AdBlockManager sharedInstance] reloadContentBlockerWithCompletion:^(NSError * _Nullable error) {
                if (error)
                {
                    NSLog(@"Error : %@", error.description);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showNextPage];
                    });
                    
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showNextPage];
                    });
                }
            }];
        }
        
    }
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([AdBlockManager sharedInstance].activated)
    {
        [self performSelector:@selector(showNextPage) withObject:nil afterDelay:2.5f];
    }

    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Utility
- (void) checkResult: (NSNotification*) notification
{
    NSError* error = notification.object;
    
    if (error)
    {
        NSLog(@"Error : %@", error.description);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showNextPage];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showNextPage];
        });
    }
}

#pragma mark - Initialization
- (void) initUI
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loading-indicator" withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data];
    self.ivAnimator.animatedImage = animatedImage1;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Utility
- (void) showNextPage
{
    if (![AppData sharedData].bShowedGuide)
    {
        [self performSegueWithIdentifier:@"guidesegue" sender:nil];
        
    }
    else
    {
        [self performSegueWithIdentifier:@"mainsegue" sender:nil];
    }
}


@end
