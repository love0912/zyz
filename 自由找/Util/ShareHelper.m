//
//  ShareHelper.m
//  自由找
//
//  Created by xiaoqi on 16/7/1.
//  Copyright © 2016年 zyz. All rights reserved.
//
#import "ShareHelper.h"
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
@implementation ShareHelper{
    CGFloat screenWidth ;
    CGFloat screenHeight;
}
@synthesize delegate;
@synthesize buttonTitles;
@synthesize buttonImages;
@synthesize v_share,lb_shareTitle,parentView,dialogView,btn_shareCancel,onButtonTouchUpInside;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        delegate = self;
    }
    return self;
}
-(void)show{
    dialogView = [self createContainerView];
    dialogView.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:dialogView];
    
    if (parentView != NULL) {
        [parentView addSubview:self];
        
    } else {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            
            UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
            switch (interfaceOrientation) {
                case UIInterfaceOrientationLandscapeLeft:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                    break;
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                    self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                    break;
                    
                default:
                    break;
            }
            
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        } else {
            
            dialogView.frame = CGRectMake(0,screenHeight-screenHeight/3, screenWidth, screenHeight/3);
            
        }
        
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }
    
    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
}
- (UIView *)createContainerView{
    if (v_share == NULL) {
        v_share = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 150)];
    }
    
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-[UIScreen mainScreen].bounds.size.height/3, [UIScreen mainScreen].bounds.size.width/ 2, [UIScreen mainScreen].bounds.size.height/3)];
    
    lb_shareTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 21)];
    lb_shareTitle.font=[UIFont systemFontOfSize:12.0];
    lb_shareTitle.textAlignment=NSTextAlignmentCenter;
    lb_shareTitle.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    lb_shareTitle.text=_shareTitle;
    [dialogContainer addSubview:lb_shareTitle];
    
    [dialogContainer addSubview:v_share];
    [self  addButtonsToView:v_share];
    
    
    btn_shareCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_shareCancel setFrame:CGRectMake(0, dialogContainer.frame.size.height-45, screenWidth, 45)];
    [btn_shareCancel setTitle:@"取消" forState:UIControlStateNormal];
    btn_shareCancel.titleLabel.font=[UIFont systemFontOfSize:15.0];
    [btn_shareCancel setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn_shareCancel addTarget:self action:@selector(ShareHelperButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btn_shareCancel setTag:9999];
    [btn_shareCancel setBackgroundColor:[UIColor whiteColor]];
    [dialogContainer addSubview:btn_shareCancel];
    
    
    
    return dialogContainer;
}
- (void)addButtonsToView: (UIView *)vshare
{
    if (buttonTitles==NULL) {
        return;
    }
    
    CGFloat buttonViewWidth = vshare.bounds.size.width /[buttonTitles count];
    //     NSArray *colorArray=@[[UIColor redColor],[UIColor greenColor],[UIColor redColor],[UIColor greenColor]];
    for (int i=0; i<[buttonTitles count]; i++) {
        
        UIView * buttonView=[[UIView alloc]init];
        if (IS_IPHONE_4_OR_LESS){
            [buttonView setFrame:CGRectMake(i*buttonViewWidth, vshare.bounds.size.height-51-45-20, buttonViewWidth, 80)];
        }else{
            [buttonView setFrame:CGRectMake(i*buttonViewWidth, vshare.bounds.size.height-51-45, buttonViewWidth, 80)];
        }
        
        [vshare addSubview:buttonView];
        //        buttonView.backgroundColor=[colorArray objectAtIndex:i];
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setFrame:CGRectMake(15, 0, buttonView.frame.size.width-30, buttonView.frame.size.width-30)];
        [shareButton setBackgroundImage:[UIImage imageNamed:[buttonImages objectAtIndex:i]] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(ShareHelperButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton setTag:i];
        [buttonView addSubview:shareButton];
        UILabel *lb_buttonTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, (buttonView.frame.size.width-30)+5,buttonView.frame.size.width, 21)];
        lb_buttonTitle.font=[UIFont systemFontOfSize:12.0];
        lb_buttonTitle.textAlignment=NSTextAlignmentCenter;
        lb_buttonTitle.textColor=[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
        lb_buttonTitle.text=[buttonTitles objectAtIndex:i];
        [buttonView addSubview:lb_buttonTitle];
    }
}
- (void)ShareHelperButtonTouchUpInside:(id)button{
    if (delegate != NULL) {
        [delegate ShareHelperButtonTouchUpInside:self clickedButtonAtIndex:[button tag]];
    }
    
    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, (int)[button tag]);
    }
    
}

- (void)ShareHelperButtonTouchUpInside: (ShareHelper *)shareHelper clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self close];
}
- (void)close
{
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}
@end
