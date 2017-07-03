//
//  VC_TextInput.h
//  自由找
//
//  Created by guojie on 16/7/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "Cell_Image.h"
#import "Cell_Upload.h"

@interface VC_TextInput : VC_Base<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CellImageDelDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UILabel *lb_tips;

/**
 *  文本字数
 */
@property (nonatomic, assign) NSInteger maxCount;

typedef void(^InputBlock)(NSString *text, NSString *imageUrls);

@property (nonatomic, strong) InputBlock inputBlock;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *imageUrls;

/**
 *  标题
 */
@property (nonatomic, strong) NSString *inputTitle;

/**
 *  提示语
 */
@property (nonatomic, strong) NSString *tipText;

/**
 *  0 -- 纯文字  1 -- 图片
 */
@property (assign, nonatomic) NSInteger type;

- (void)setText:(NSString *)text maxCount:(NSInteger)count;

- (void)setText:(NSString *)text maxCount:(NSInteger)count imageUrls:(NSString *)urls;

/**
 *  上传图片视图
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_backView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_collectionView_height;


@end
