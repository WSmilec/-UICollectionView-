//
//  WSPropertySelectionViewByCollectionView.m
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import "WSPropertySelectionViewByCollectionView.h"
#import "WSPropertySelectionFlowLayout.h"
#import "Masonry.h"
#import "WSHeaderCollectionReusableView.h"
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])

#define WIDTH_RATIO        (CGRectGetWidth([[UIScreen mainScreen] bounds]) / 750.0)
#define HEIGHT_RATIO       (CGRectGetHeight([[UIScreen mainScreen] bounds]) / 1334.0)
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

@interface WSPropertySelectionViewByCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,WSPropertySelectionFlowLayoutDelegate>
@property (nonatomic,strong) UICollectionView  *myCollectionView;
@property (nonatomic,strong) NSArray   *propertiesArr;
@property (nonatomic,strong) NSArray   *ruleArr;
@property (nonatomic,assign) CGFloat   maxHeight;

@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) NSMutableArray *selectArr;
@property (nonatomic,strong) NSMutableDictionary *selectDict;
@property (nonatomic,strong) NSMutableArray *noSelectArr;
@end

@implementation WSPropertySelectionViewByCollectionView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<WSPropertySelectionViewByCollectionViewDelegate>)aDelegate{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = aDelegate;
        [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)refreshWithTags:(NSArray *)propertiesArr rule:(NSArray *)ruleArr{
    
    self.propertiesArr = propertiesArr;
    self.ruleArr = ruleArr;
    [self.myCollectionView reloadData];
}
- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray new];
    }
    return _selectArr;
}
- (NSMutableDictionary *)selectDict{
    if (!_selectDict) {
        _selectDict = [NSMutableDictionary new];
    }
    return _selectDict;
}
- (NSMutableArray *)noSelectArr{
    if (!_noSelectArr) {
        _noSelectArr = [NSMutableArray new];
    }
    return _noSelectArr;
}
- (UICollectionView *)myCollectionView{
    if(!_myCollectionView){
        WSPropertySelectionFlowLayout *layout = [[WSPropertySelectionFlowLayout alloc] init];
        layout.rowHeight = 60 * HEIGHT_RATIO;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 40);
        layout.delegate = self;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.scrollEnabled = YES;
        [self addSubview:_myCollectionView];
        [_myCollectionView registerClass:[WSPropertySelectionViewCell class] forCellWithReuseIdentifier:@"WSPropertySelectionViewCell"];
        [_myCollectionView registerClass:[WSHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WSHeaderCollectionReusableView"];
    }
    return _myCollectionView;
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.propertiesArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *propertiesDict = self.propertiesArr[section];
    NSArray *valuesArr = propertiesDict[@"values"];
    return valuesArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self cellSize:indexPath];
    return CGSizeMake(width, 60 * HEIGHT_RATIO);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        WSHeaderCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"WSHeaderCollectionReusableView" forIndexPath:indexPath];
        NSDictionary *propertiesDict = self.propertiesArr[indexPath.section];
        reusableView.sectionHeaderStr = propertiesDict[@"name"];
        return reusableView;
    }
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WSPropertySelectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WSPropertySelectionViewCell" forIndexPath:indexPath];
    NSDictionary *propertiesDict = self.propertiesArr[indexPath.section];
    NSArray *valuesArr = propertiesDict[@"values"];
    NSDictionary *valuesDict = valuesArr[indexPath.row];
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:valuesDict];
    if (self.selectArr.count > 0) {
        if ([self.selectArr containsObject:valuesDict]) {
            [mutDict setValue:@(ShowTypeWithSelect) forKey:@"showType"];
            cell.valueDict = mutDict;
            return cell;
        }
        BOOL unSelect = NO;
        if (self.section == indexPath.section) {
            for (NSDictionary *ruleDict in self.ruleArr) {
                NSSet *ruleSet = [NSSet setWithArray:ruleDict[@"content"]];
                NSSet *valueSet = [NSSet setWithArray:@[valuesDict]];
                NSSet *selectSet = [NSSet setWithArray:self.selectArr];
                if ([valueSet isSubsetOfSet:ruleSet]) {
                    if (self.selectArr.count > 1) {
                        if ([selectSet isSubsetOfSet:ruleSet]) {
                            unSelect = YES;
                        }
                    }else{
                        unSelect = YES;
                    }
                }
            }
        }
        for (NSDictionary *ruleDict in self.ruleArr) {
            NSSet *ruleSet = [NSSet setWithArray:ruleDict[@"content"]];
            NSSet *selectSet = [NSSet setWithArray:self.selectArr];
            if ([selectSet isSubsetOfSet:ruleSet]) {
                for (NSDictionary *ruleValueDict in ruleDict[@"content"]) {
                    if ([ruleValueDict isEqual:valuesDict]) {
                        unSelect = YES;
                    }
                }
            }else{
                NSMutableDictionary *otherDict = [[NSMutableDictionary alloc] initWithDictionary:self.selectDict];
                [otherDict setValue:valuesDict forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
                NSMutableArray *otherArr = [NSMutableArray new];
                for (NSString *key in otherDict.allKeys) {
                    [otherArr addObject:otherDict[key]];
                }
                NSSet *otherSet = [NSSet setWithArray:otherArr];
                if ([otherSet isSubsetOfSet:ruleSet]) {
                    for (NSDictionary *ruleValueDict in ruleDict[@"content"]) {
                        if ([ruleValueDict isEqual:valuesDict]) {
                            unSelect = YES;
                        }
                    }
                }
            }
        }
        
        if (unSelect) {
            [mutDict setValue:@(ShowTypeWithUnSelect) forKey:@"showType"];
        }else{
            [mutDict setValue:@(ShowTypeWithNoSelect) forKey:@"showType"];
            [self.noSelectArr addObject:valuesDict];
        }
        
    }else{
        BOOL unSelect = NO;
        for (NSDictionary *ruleDict in self.ruleArr) {
            for (NSDictionary *ruleValueDict in ruleDict[@"content"]) {
                if ([ruleValueDict isEqual:valuesDict]) {
                    unSelect = YES;
                }
            }
        }
        if (unSelect) {
            [mutDict setValue:@(ShowTypeWithUnSelect) forKey:@"showType"];
        }else{
            [mutDict setValue:@(ShowTypeWithNoSelect) forKey:@"showType"];
            [self.noSelectArr addObject:valuesDict];
        }
    }
    cell.valueDict = mutDict;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *propertiesDict = self.propertiesArr[indexPath.section];
    NSArray *valuesArr = propertiesDict[@"values"];
    NSDictionary *valuesDict = valuesArr[indexPath.row];
    for (NSDictionary *noSelectDict in self.noSelectArr) {
        if ([noSelectDict isEqual:valuesDict]) {
            return;
        }
    }
    if ([[self.selectDict objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]] isEqual:valuesDict]) {
        [self.selectDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    }else{
        [self.selectDict setValue:valuesDict forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    }
    
    [self.selectArr removeAllObjects];
    for (NSString *key in self.selectDict.allKeys) {
        [self.selectArr addObject:self.selectDict[key]];
    }
    self.section = indexPath.section;
    [self.noSelectArr removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(goodsParameterView:selectedValueArr:)]) {
        [self.delegate goodsParameterView:self selectedValueArr:self.selectArr];
    }
    [collectionView reloadData];
    
}
- (CGFloat)waterFlowLayout:(WSPropertySelectionFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = [self cellSize:indexPath];
    return width;
}
- (CGFloat)cellSize:(NSIndexPath *)indexPath{
    NSDictionary *propertiesDict = self.propertiesArr[indexPath.section];
    NSArray *valuesArr = propertiesDict[@"values"];
    NSDictionary *valuesDict = valuesArr[indexPath.row];
    NSString *str = valuesDict[@"name"];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20 - 20 * WIDTH_RATIO,CGFLOAT_MAX);
    CGRect textRect = [str
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       context:nil];
    CGFloat width = textRect.size.width + 15;
    return width;
}

@end

#pragma mark---标签cell
@interface WSPropertySelectionViewCell ()
@property (nonatomic,strong) UIButton *btn;
@end
@implementation WSPropertySelectionViewCell


- (void)layoutSubviews{
    [super layoutSubviews];
    self.btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn.layer.borderWidth = 1.f;
        _btn.layer.borderColor = UIColorFromHex(0x999999).CGColor;
        _btn.layer.cornerRadius = 5;
        _btn.layer.masksToBounds = YES;
        _btn.userInteractionEnabled = NO;
        [_btn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        _btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_btn];
    }
    return _btn;
}
- (void)setValueDict:(NSDictionary *)valueDict{
    _valueDict = valueDict;
    
    [self.btn setTitle:valueDict[@"name"] forState:UIControlStateNormal];
    
    NSInteger showType = 0;
    if ([valueDict objectForKey:@"showType"]) {
        showType = [[valueDict objectForKey:@"showType"] integerValue];
    }
    switch (showType) {
        case ShowTypeWithSelect:
            [_btn setTitleColor:UIColorFromHex(0xfc4e57) forState:UIControlStateNormal];
            _btn.layer.borderColor = UIColorFromHex(0xfc4e57).CGColor;
            break;
        case ShowTypeWithUnSelect:
            [_btn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
            _btn.layer.borderColor = UIColorFromHex(0x999999).CGColor;
            break;
        case ShowTypeWithNoSelect:
            [_btn setTitleColor:UIColorFromHex(0xe6e6e6) forState:UIControlStateNormal];
            _btn.layer.borderColor = UIColorFromHex(0xe6e6e6).CGColor;
            break;
        default:
            break;
    }
}



@end
