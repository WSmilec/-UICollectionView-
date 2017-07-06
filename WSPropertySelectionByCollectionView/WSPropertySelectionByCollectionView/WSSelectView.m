//
//  WSSelectView.m
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import "WSSelectView.h"
#import "WSPropertySelectionViewByCollectionView.h"
#define SCREEN_WIDTH   CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT  CGRectGetHeight([[UIScreen mainScreen] bounds])
#define WIDTH_RATIO   (CGRectGetWidth([[UIScreen mainScreen] bounds]) / 750.0)
#define HEIGHT_RATIO  (CGRectGetHeight([[UIScreen mainScreen] bounds]) / 1334.0)
@interface WSSelectView ()<WSPropertySelectionViewByCollectionViewDelegate>
@property (nonatomic,strong) WSPropertySelectionViewByCollectionView *propertySelectionView;
@end
@implementation WSSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.propertySelectionView.frame = CGRectMake(0, SCREEN_HEIGHT - 400, SCREEN_WIDTH, 400);
}
- (void)loadDatas{
    [self.propertySelectionView refreshWithTags:self.propertiesArr rule:self.ruleArr];
}
- (WSPropertySelectionViewByCollectionView *)propertySelectionView{
    if (!_propertySelectionView) {
        _propertySelectionView = [[WSPropertySelectionViewByCollectionView alloc] initWithFrame:CGRectZero delegate:self];
        [self addSubview:_propertySelectionView];
    }
    return _propertySelectionView;
}
@end
