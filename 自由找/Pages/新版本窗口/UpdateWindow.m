//
//  UpdateWindow.m
//  自由找
//
//  Created by 郭界 on 16/9/21.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "UpdateWindow.h"
#import "Masonry.h"
#import "BaseConstants.h"

@implementation UpdateWindow
{
    UILabel *_lb_title;
    UILabel *_lb_content;
    UIScrollView *_scroll_content;
    NSString *_downloadUrlString;
    
    UIButton *_btn_cancel;
    UIButton *_btn_update;
    UIView *_v_content;
    
    BOOL _isShowed;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(UpdateWindow *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return sharedInstance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        UIView *v_content = [[UIView alloc] init];
        v_content.backgroundColor = [UIColor whiteColor];
        v_content.layer.masksToBounds = YES;
        v_content.layer.cornerRadius = 5;
        v_content.translatesAutoresizingMaskIntoConstraints = NO;
        _v_content = v_content;
        [self addSubview:v_content];
        CGFloat width = ScreenSize.width * 0.8;
        CGFloat height = width * 1.048;
        
        [v_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(ScreenSize.width * 0.1);
            make.right.equalTo(self.mas_right).with.offset(-ScreenSize.width * 0.1);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
        UIImageView *imgv_logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updateLogo"]];
        [v_content addSubview:imgv_logo];
        [imgv_logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(v_content.mas_top);
            make.left.equalTo(v_content.mas_left);
            make.right.equalTo(v_content.mas_right);
            make.height.mas_equalTo(width * 0.2);
        }];
        UILabel *lb_title = [[UILabel alloc] init];
        lb_title.textColor = [UIColor colorWithHex:@"333333"];
        lb_title.font = [UIFont systemFontOfSize:16];
        lb_title.text = @"发现新版本";
        _lb_title = lb_title;
        [v_content addSubview:lb_title];
        [lb_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(v_content.mas_left).with.offset(21);
            make.top.equalTo(imgv_logo.mas_bottom).with.offset(30);
        }];
//
        UIScrollView *contentScrollView = [[UIScrollView alloc] init];
        _scroll_content = contentScrollView;
        contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        contentScrollView.showsVerticalScrollIndicator = NO;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        [v_content addSubview:contentScrollView];
        [contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lb_title.mas_bottom).with.offset(13);
            make.left.equalTo(v_content.mas_left).with.offset(21);
            make.right.equalTo(v_content.mas_right).with.offset(-21);
            make.bottom.equalTo(v_content.mas_bottom).with.offset(-45);
        }];
        UILabel *contentLabel = [[UILabel alloc] init];
        _lb_content = contentLabel;
        contentLabel.textColor = [UIColor colorWithHex:@"666666"];
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.contentMode = UIViewContentModeTopLeft;
        [contentScrollView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentScrollView.mas_top);
            make.left.equalTo(contentScrollView.mas_left);
            make.bottom.equalTo(contentScrollView.mas_bottom);
            make.right.equalTo(contentScrollView.mas_right);
        }];
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = [UIColor colorWithHex:@"dddddd"];
        [v_content addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentScrollView.mas_bottom);
            make.left.equalTo(v_content.mas_left);
            make.right.equalTo(v_content.mas_right);
            make.height.mas_equalTo(1);
        }];
        
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setTitleColor:[UIColor colorWithHex:@"999999"] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _btn_cancel = cancelButton;
        [v_content addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(v_content.mas_left);
            make.top.equalTo(lineLabel.mas_bottom);
            make.bottom.equalTo(v_content.mas_bottom);
            make.width.mas_equalTo(width/2);
        }];
        [cancelButton addTarget:self action:@selector(animationClose:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [updateButton setTitleColor:[UIColor colorWithHex:@"fe7c21"] forState:UIControlStateNormal];
        [updateButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _btn_update = updateButton;
        [v_content addSubview:updateButton];
        [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(v_content.mas_right);
            make.top.equalTo(lineLabel.mas_bottom);
            make.bottom.equalTo(v_content.mas_bottom);
            make.width.mas_equalTo(width/2);
        }];
        [updateButton addTarget:self action:@selector(updateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showInContent:(NSString *)content version:(NSString *)version donwloadUrlString:(NSString *)urlString type:(NSInteger)type {
    _downloadUrlString = urlString;
    _lb_title.text = [NSString stringWithFormat:@"发现%@新版本", version];
    _lb_content.text = [content stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];//@"1、aaaa\n2、bbbb\n3、cccc\n4、dddd\n5、aaaa\n6、bbbb\n7、cccc\n8、dddd";
    _scroll_content.contentSize = _lb_content.bounds.size;
    if (type == 1) {
        _btn_cancel.hidden = YES;
        [_btn_update mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_v_content.mas_right);
            make.bottom.equalTo(_v_content.mas_bottom);
            make.left.equalTo(_v_content.mas_left);
        }];
    }
    
    
    self.hidden = NO;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

//- (void)animationBegion {
//    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
//    animation.duration = 0.5;
//    NSMutableArray *values = [NSMutableArray array];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
//    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
//    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
//    animation.values = values;
//    [_v_content.layer addAnimation:animation forKey:nil];
//}
//
//- (void)animationDidStart:(CAAnimation *)anim {
//}
//
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    self.userInteractionEnabled = YES;
//}

- (void)animationClose:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

- (void)updateButtonPressed:(id)sender {
    if ([_downloadUrlString hasPrefix:@"https"]) {
        _downloadUrlString = [_downloadUrlString stringByReplacingOccurrencesOfString:@"https" withString:@"itms-apps"];
    } else {
        if ([_downloadUrlString hasPrefix:@"http"]) {
           _downloadUrlString = [_downloadUrlString stringByReplacingOccurrencesOfString:@"http" withString:@"itms-apps"];
        }
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadUrlString]];
}

@end
