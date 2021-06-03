//
//  GuideVC.m
//  AdBlockerPro
//
//  Created by Passion on 9/30/15.
//  Copyright © 2015 dakyuz. All rights reserved.
//

#import "GuideVC.h"
#import "Constant.h"

@interface GuideVC ()<UIScrollViewDelegate>

#pragma mark - Sub Views

@property (weak, nonatomic) IBOutlet UIView *viewGuide1;
@property (weak, nonatomic) IBOutlet UIView *viewGuide2;
@property (weak, nonatomic) IBOutlet UIView *viewGuide3;
@property (weak, nonatomic) IBOutlet UIView *viewGuide4;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrGuide;
@property (weak, nonatomic) IBOutlet UIImageView *iv1;
@property (weak, nonatomic) IBOutlet UIImageView *iv2;
@property (weak, nonatomic) IBOutlet UIImageView *iv3;

@property (weak, nonatomic) IBOutlet UIImageView *ivExt1;
@property (weak, nonatomic) IBOutlet UIImageView *ivExt2;
@property (weak, nonatomic) IBOutlet UIImageView *ivExt3;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@end

@implementation GuideVC

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Guide Screen";
    
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Init
- (void) initUI
{
//    self.scrGuide.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
//    self.scrGuide.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
//    self.viewGuide1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.viewGuide2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.viewGuide3.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    self.viewGuide4.frame = CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self.btnClose setTitle:NSLocalizedString(@"Close", @"") forState:UIControlStateNormal];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.scrGuide.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        self.scrGuide.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
        self.viewGuide1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewGuide2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewGuide3.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewGuide4.hidden = YES;
        
        self.iv1.image = [UIImage imageNamed:@"intro-1_iPad.png"];
        self.iv2.image = [UIImage imageNamed:@"Intro-2_iPad.png"];
        self.iv3.image = [UIImage imageNamed:@"Intro-3_iPad.png"];
        
        self.ivExt1.hidden = YES;
        self.ivExt2.hidden = YES;
        self.ivExt3.hidden = YES;
        
        self.btnNext.hidden = NO;
        
        self.pageControl.numberOfPages = 3;
    }
    else
    {
        self.scrGuide.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
        self.scrGuide.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
        self.viewGuide1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewGuide2.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewGuide3.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.viewGuide4.frame = CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        self.viewGuide4.hidden = NO;
        
        
        UIImage* imageTemp1 = [UIImage imageNamed:@"intro-1.png"];
        UIImage* imageTemp2 = [UIImage imageNamed:@"Intro-2.png"];
        UIImage* imageTemp3 = [UIImage imageNamed:@"Intro-3.png"];
        
        self.iv1.image = imageTemp1;
        self.iv2.image = imageTemp2;
        self.iv3.image = imageTemp3;
        
        self.ivExt1.hidden = NO;
        self.ivExt2.hidden = NO;
        self.ivExt3.hidden = NO;
        
        self.btnNext.hidden = YES;

        self.pageControl.numberOfPages = 4;
    }
}

#pragma mark - User Interaction
- (IBAction)clickNext:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)pageChanged:(UIPageControl *)sender
{
    NSInteger nPageNum = sender.currentPage;
    CGFloat pageWidth = self.scrGuide.frame.size.width;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.scrGuide.contentOffset = CGPointMake(nPageNum * pageWidth, 0);
    }];
}



#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrGuide.frame.size.width;
    int page = floor((self.scrGuide.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
