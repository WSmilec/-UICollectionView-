//
//  WSPropertySelectionFlowLayout.m
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import "WSPropertySelectionFlowLayout.h"
@interface WSPropertySelectionFlowLayout ()
@property (nonatomic,strong)NSMutableArray *itemAttributes;
@property (nonatomic,strong)NSMutableArray *originxArray;
@property (nonatomic,strong)NSMutableArray *originyArray;
@end
@implementation WSPropertySelectionFlowLayout
#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLayout];
        _originxArray = [NSMutableArray array];
        _originyArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupLayout{
    self.minimumInteritemSpacing = 24;//同一行不同cell间距
    self.minimumLineSpacing = 8;//行间距
    self.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark - 所有cell和view的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    for(UICollectionViewLayoutAttributes *attrs in array){
        //类型判断
        if(attrs.representedElementCategory == UICollectionElementCategoryCell){
            UICollectionViewLayoutAttributes *theAttrs = [self layoutAttributesForItemAtIndexPath:attrs.indexPath];
            CGRect frame = attrs.frame;
            frame.origin.x = theAttrs.frame.origin.x;
            attrs.frame = frame;
        }
    }
    return array;
}

#pragma mark - 指定cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat x = self.sectionInset.left;
    //如果有sectionheader需要加上sectionheader高度
    CGFloat y = self.headerReferenceSize.height * indexPath.section + self.sectionInset.top;
    //判断获得前一个cell的x和y
    NSInteger preRow = indexPath.row - 1;
    if(preRow >= 0){
        if(_originyArray.count > preRow){
            x = [_originxArray[preRow]floatValue];
            y = [_originyArray[preRow]floatValue];
        }
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preRow inSection:indexPath.section];
        CGFloat preWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:preIndexPath];
        x += preWidth + self.minimumInteritemSpacing;
    }
    
    CGFloat currentWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:indexPath];
    //保证一个cell不超过最大宽度
    currentWidth = MIN(currentWidth, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right);
    if(x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right){
        //超出范围，换行
        x = self.sectionInset.left;
        y += _rowHeight + self.minimumLineSpacing;
    }
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, currentWidth, _rowHeight);
    _originxArray[indexPath.row] = @(x);
    _originyArray[indexPath.row] = @(y);
    
    return attrs;
}

@end
