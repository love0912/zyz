//
//  JRateView.m
//  自由找
//
//  Created by guojie on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "JRateView.h"

#define FOREGROUND_STAR_IMAGE_NAME @"pingjia_full"
#define BACKGROUND_STAR_IMAGE_NAME @"pingjia_none"
#define DEFALUT_STAR_NUMBER 5
#define ANIMATION_TIME_INTERVAL 0.2
#define STARWIDTH 12.5

@interface JRateView ()

@property (nonatomic, assign) CGFloat scorePercent;//得分值，范围为0--1，默认为1
@property (nonatomic, assign) BOOL isAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic, assign) NSInteger numberOfStars;

@property (nonatomic, assign) CGFloat paddingX;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation JRateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+ (JRateView *)rateScoreWithFrame:(CGRect)frame paddingX:(CGFloat)paddingX Score:(CGFloat)score isAnimation:(BOOL)animate allowIncompleteStar:(BOOL)allow rateScore:(void (^)(CGFloat score))rateScore {
    JRateView *ratting = [[JRateView alloc] initWithFrame:frame];
    ratting.numberOfStars = DEFALUT_STAR_NUMBER;
    ratting.paddingX = paddingX;
    ratting.isAnimation = animate;
    ratting.allowIncompleteStar = allow;
    ratting.rateScore = rateScore;
    ratting.scorePercent = score;
    [ratting layoutUI];
    return ratting;
}


- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars {
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
    }
    return self;
}

- (void)layoutUI {
    self.foregroundStarView = [self createStarViewWithImage:FOREGROUND_STAR_IMAGE_NAME];
    self.backgroundStarView = [self createStarViewWithImage:BACKGROUND_STAR_IMAGE_NAME];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
}

- (void)setIsTap:(BOOL)isTap {
    if (isTap) {
        if (self.tapGesture == nil) {
            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
            self.tapGesture.numberOfTapsRequired = 1;
        }
        [self removeGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.tapGesture];
    } else {
        if (self.tapGesture != nil) {
            [self removeGestureRecognizer:self.tapGesture];
        }
    }
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (STARWIDTH + self.paddingX);
    CGFloat intScore = floorf(realStarScore);
    CGFloat decimal = realStarScore - intScore;
    if (decimal < 0.5f) {
        decimal = 0.5f;
    } else {
        decimal = 1.0f;
    }
    self.scorePercent = intScore + decimal;
//    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
//    self.scorePercent = starScore / self.numberOfStars;
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (STARWIDTH + self.paddingX), 0, STARWIDTH, STARWIDTH);
        CGPoint center = imageView.center;
        center.y = view.center.y;
        imageView.center = center;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak JRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? ANIMATION_TIME_INTERVAL : 0;
    int scoreInt = floorf(self.scorePercent);
    CGFloat ScoreFloat = self.scorePercent - scoreInt;
    CGFloat width = scoreInt * (STARWIDTH + self.paddingX) + ScoreFloat * STARWIDTH;
    CGRect frame = self.foregroundStarView.frame;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        weakSelf.foregroundStarView.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    }];
}

- (void)setScorePercent:(CGFloat)scroePercent {
    if (_scorePercent == scroePercent) {
        return;
    }
    
    if (scroePercent < 0) {
        _scorePercent = 0;
    } else if (scroePercent > 5) {
        _scorePercent = 5;
    } else {
        _scorePercent = scroePercent;
    }
    
    self.rateScore(scroePercent);
    
    [self setNeedsLayout];
}

@end
