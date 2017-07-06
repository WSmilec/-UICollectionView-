//
//  WSPropertySelectionViewByCollectionView.h
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShowType) {//展示类型
    ShowTypeWithUnSelect,//未选
    ShowTypeWithSelect,//已选
    ShowTypeWithNoSelect//不可选
};
@class WSPropertySelectionViewByCollectionView;
@protocol WSPropertySelectionViewByCollectionViewDelegate <NSObject>
- (void)goodsParameterView:(WSPropertySelectionViewByCollectionView *)goodsParameterView selectedValueArr:(NSArray *)valueArr;
@end
@interface WSPropertySelectionViewByCollectionView : UIView
@property (nonatomic,weak) id<WSPropertySelectionViewByCollectionViewDelegate>delegate;
@property (nonatomic,copy) void(^maxHeightBlock)(CGFloat maxHeight);
@property (nonatomic,copy) void(^goodsCountBlock)(NSString *goodsCountStr);
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WSPropertySelectionViewByCollectionViewDelegate>)aDelegate;
- (void)refreshWithTags:(NSArray *)tags rule:(NSArray *)ruleArr;
@end
#pragma mark---标签cell
@interface WSPropertySelectionViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *tagStr;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSDictionary *valueDict;
@end
