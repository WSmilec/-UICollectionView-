//
//  WSPropertySelectionFlowLayout.h
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSPropertySelectionFlowLayout;
@protocol  WSPropertySelectionFlowLayoutDelegate<UICollectionViewDelegateFlowLayout>
- (CGFloat)waterFlowLayout:(WSPropertySelectionFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface WSPropertySelectionFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,weak) id<WSPropertySelectionFlowLayoutDelegate> delegate;
@property (nonatomic,assign) CGFloat rowHeight;
@end
