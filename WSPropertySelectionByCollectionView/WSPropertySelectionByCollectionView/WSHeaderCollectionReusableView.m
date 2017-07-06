//
//  WSHeaderCollectionReusableView.m
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import "WSHeaderCollectionReusableView.h"
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
@interface WSHeaderCollectionReusableView ()
@property (nonatomic,strong) UILabel *headerLab;
@end
@implementation WSHeaderCollectionReusableView
- (void)setSectionHeaderStr:(NSString *)sectionHeaderStr{
    _sectionHeaderStr = sectionHeaderStr;
    
    self.headerLab.text = sectionHeaderStr;
}

- (UILabel *)headerLab{
    if (!_headerLab) {
        _headerLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, [UIScreen mainScreen].bounds.size.width - 12, 16)];
        _headerLab.font = [UIFont systemFontOfSize:16];
        _headerLab.textColor = UIColorFromHex(0x333333);
        _headerLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_headerLab];
    }
    return _headerLab;
}
@end
