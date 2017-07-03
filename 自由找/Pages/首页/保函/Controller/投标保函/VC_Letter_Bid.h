//
//  VC_Letter_Bid.h
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Letter_Bid : VC_Base<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)btn_backToTop_pressed:(id)sender;
@end
