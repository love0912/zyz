//
//  RatingBar.m
//  自由找
//
//  Created by guojie on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "RatingBar.h"
#import "BaseConstants.h"

@interface RatingBar (){
    float starRating;
    float lastRating;
    
    float height;
    float width;
    float padding_x;
    
    UIImage *unSelectedImage;
    UIImage *halfSelectedImage;
    UIImage *fullSelectedImage;
}

@property (nonatomic,strong) UIImageView *s1;
@property (nonatomic,strong) UIImageView *s2;
@property (nonatomic,strong) UIImageView *s3;
@property (nonatomic,strong) UIImageView *s4;
@property (nonatomic,strong) UIImageView *s5;

@property (nonatomic, strong) UILabel *lb_title;

/**
 *  整数部分的label
 */
@property (nonatomic, strong) UILabel *lb_int;
/**
 *  小数部分的label
 */
@property (nonatomic, strong) UILabel *lb_decimal;

@property (nonatomic,weak) id<RatingBarDelegate> delegate;

@end

@implementation RatingBar

/**
 *  初始化设置未选中图片、半选中图片、全选中图片，以及评分值改变的代理（可以用
 *  Block）实现
 *
 *  @param deselectedName   未选中图片名称
 *  @param halfSelectedName 半选中图片名称
 *  @param fullSelectedName 全选中图片名称
 *  @param delegate          代理
 */
-(void)setImageDeselected:(NSString *)deselectedName halfSelected:(NSString *)halfSelectedName fullSelected:(NSString *)fullSelectedName andDelegate:(id<RatingBarDelegate>)delegate{
    
    deselectedName = @"ApplyCompany_pjx2";
    halfSelectedName = @"ApplyCompany_pjx3";
    fullSelectedName = @"ApplyCompany_pjx1";
    
    self.delegate = delegate;
    
    unSelectedImage = [UIImage imageNamed:deselectedName];
    halfSelectedImage = halfSelectedName == nil ? unSelectedImage : [UIImage imageNamed:halfSelectedName];
    fullSelectedImage = [UIImage imageNamed:fullSelectedName];
    
    height = 0.0,width = 0.0;
    
    if (height < [fullSelectedImage size].height) {
        height = [fullSelectedImage size].height;
    }
    if (height < [halfSelectedImage size].height) {
        height = [halfSelectedImage size].height;
    }
    if (height < [unSelectedImage size].height) {
        height = [unSelectedImage size].height;
    }
    if (width < [fullSelectedImage size].width) {
        width = [fullSelectedImage size].width;
    }
    if (width < [halfSelectedImage size].width) {
        width = [halfSelectedImage size].width;
    }
    if (width < [unSelectedImage size].width) {
        width = [unSelectedImage size].width;
    }
    
    starRating = 0.0;
    lastRating = 0.0;
    
    _s1 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s2 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s3 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s4 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s5 = [[UIImageView alloc] initWithImage:unSelectedImage];
    
    CGFloat paddingBottom = 26;
    padding_x = (self.size.width - (width * 5)) / 6;
    
    [_s1 setFrame:CGRectMake(padding_x, self.size.height - height - paddingBottom, width, height)];
    [_s2 setFrame:CGRectMake(padding_x + (padding_x + width),     self.size.height - height - paddingBottom, width, height)];
    [_s3 setFrame:CGRectMake(padding_x + 2 * (width + padding_x), self.size.height - height - paddingBottom, width, height)];
    [_s4 setFrame:CGRectMake(padding_x + 3 * (width + padding_x), self.size.height - height - paddingBottom, width, height)];
    [_s5 setFrame:CGRectMake(padding_x + 4 * (width + padding_x), self.size.height - height - paddingBottom, width, height)];
    
    [_s1 setUserInteractionEnabled:NO];
    [_s2 setUserInteractionEnabled:NO];
    [_s3 setUserInteractionEnabled:NO];
    [_s4 setUserInteractionEnabled:NO];
    [_s5 setUserInteractionEnabled:NO];
    
    [self addSubview:_s1];
    [self addSubview:_s2];
    [self addSubview:_s3];
    [self addSubview:_s4];
    [self addSubview:_s5];
    
    _lb_title = [[UILabel alloc] init];
    _lb_title.textColor = [UIColor colorWithHex:@"666666"];
    _lb_title.text = _titleText == nil ? @"请评价" : _titleText;
    _lb_title.font = [UIFont systemFontOfSize:15];
    [self addSubview:_lb_title];
    _lb_title.frame = CGRectMake(0, 0, 120, 20);
    _lb_title.textAlignment = NSTextAlignmentRight;
    CGPoint point = CGPointMake(self.width/2, self.height / 2);
    point.x = point.x - 36;
    point.y = 38;
    _lb_title.center = point;
    
    _lb_int = [[UILabel alloc] init];
    _lb_int.textColor = [UIColor colorWithHex:@"ff7b23"];
    _lb_int.font = [UIFont systemFontOfSize:28];
    _lb_int.text = @"0";
    _lb_int.frame = CGRectMake(0, 0, 17, 26);
    CGPoint intCenter = _lb_title.center;
    intCenter.x = intCenter.x + _lb_title.size.width/2 + 10;
    intCenter.y = intCenter.y - 4;
    _lb_int.center = intCenter;
    [self addSubview:_lb_int];
    _lb_decimal = [[UILabel alloc] init];
    _lb_decimal.textColor = [UIColor colorWithHex:@"ff7b23"];
    _lb_decimal.font = [UIFont systemFontOfSize:15];
    _lb_decimal.text = @".0";
    _lb_decimal.frame = CGRectMake(_lb_int.origin.x + _lb_int.size.width, _lb_int.origin.y, 15, 15);
    [self addSubview:_lb_decimal];
    
    
//    CGRect frame = [self frame];
//    frame.size.width = width * 5;
////    frame.size.height = height + _lb_title.size.height + 50;
//    [self setFrame:frame];
    
    
    
    
}

/**
 *  设置评分值
 *
 *  @param rating 评分值
 */
-(void)displayRating:(float)rating{
    [_s1 setImage:unSelectedImage];
    [_s2 setImage:unSelectedImage];
    [_s3 setImage:unSelectedImage];
    [_s4 setImage:unSelectedImage];
    [_s5 setImage:unSelectedImage];
    
    if (rating > 0.2) {
        [_s1 setImage:halfSelectedImage];
    }
    if (rating >= 0.7) {
        [_s1 setImage:fullSelectedImage];
    }
    if (rating > 1.2) {
        [_s2 setImage:halfSelectedImage];
    }
    if (rating >= 1.7) {
        [_s2 setImage:fullSelectedImage];
    }
    if (rating >= 2.2) {
        [_s3 setImage:halfSelectedImage];
    }
    if (rating >= 2.7) {
        [_s3 setImage:fullSelectedImage];
    }
    if (rating >= 3.2) {
        [_s4 setImage:halfSelectedImage];
    }
    if (rating >= 3.7) {
        [_s4 setImage:fullSelectedImage];
    }
    if (rating >= 4.2) {
        [_s5 setImage:halfSelectedImage];
    }
    if (rating >= 4.7) {
        [_s5 setImage:fullSelectedImage];
    }
    
    starRating = rating;
    lastRating = rating;
    if (rating < 0.2) {
        rating = 0;
    } else if (rating >= 0.2 && rating < 0.7) {
        rating = 0.5;
    } else if (rating >=0.7 && rating <=1.2) {
        rating = 1.0;
    } else if (rating >=1.2 && rating <=1.7) {
        rating = 1.5;
    } else if (rating >=1.7 && rating <=2.2) {
        rating = 2.0;
    } else if (rating >=2.2 && rating <=2.7) {
        rating = 2.5;
    } else if (rating >=2.7 && rating <=3.2) {
        rating = 3.0;
    } else if (rating >=3.2 && rating <=3.7) {
        rating = 3.5;
    } else if (rating >=3.7 && rating <=4.2) {
        rating = 4.0;
    } else if (rating >=4.2 && rating <=4.7) {
        rating = 4.5;
    } else {
        rating = 5.0;
    }
    NSString *ratingString = [NSString stringWithFormat:@"%.1f", rating];
    NSArray *arr_rating = [ratingString componentsSeparatedByString:@"."];
    _lb_int.text = arr_rating.firstObject;
    _lb_decimal.text = [NSString stringWithFormat:@".%@", arr_rating.lastObject];
    [_delegate ratingChanged:rating];
}

/**
 *  获取当前的评分值
 *
 *  @return 评分值
 */
-(float)rating{
    return starRating;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.isIndicator) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    [self showScoreWithPoint:point];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if ([_delegate respondsToSelector:@selector(finishRating)]) {
        [_delegate finishRating];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self showScoreWithPoint:point];
}

- (void)showScoreWithPoint:(CGPoint) point {
    float newRating = (point.x / (width + padding_x));
    if (newRating > 5)
        return;
    
    if (point.x < 0) {
        newRating = 0;
    }
    
    if (newRating != lastRating){
        [self displayRating:newRating];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
