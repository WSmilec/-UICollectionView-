//
//  WSSelectView.h
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSSelectView : UIView
@property (nonatomic,strong) NSArray *propertiesArr;
@property (nonatomic,strong) NSArray *ruleArr;
- (void)loadDatas;
@end
