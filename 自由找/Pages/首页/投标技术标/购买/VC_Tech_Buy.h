//
//  VC_Tech_Buy.h
//  自由找
//
//  Created by guojie on 16/7/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Tech_Buy : VC_Base<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 *  1 -- 技术标购买, 2 -- 投标预算标购买
 */
@property (assign, nonatomic) NSInteger type;

@end
