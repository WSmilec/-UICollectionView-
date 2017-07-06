//
//  ViewController.m
//  WSPropertySelectionByCollectionView
//
//  Created by WangS on 2017/7/6.
//  Copyright © 2017年 WangS. All rights reserved.
//

#import "ViewController.h"
#import "WSSelectView.h"
#define SCREEN_WIDTH   CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT  CGRectGetHeight([[UIScreen mainScreen] bounds])
@interface ViewController ()
@property (nonatomic,strong) NSArray *propertiesArr;
@property (nonatomic,strong) NSArray *ruleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(20, 100, SCREEN_WIDTH - 40, 30);
    [selectBtn setTitle:@"商城属性选择ByCollectionView" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    
    self.propertiesArr = @[@{@"name":@"颜色",@"values":@[@{@"name":@"红"},@{@"name":@"黄"},@{@"name":@"绿"}]},@{@"name":@"材质",@"values":@[@{@"name":@"亚克力"},@{@"name":@"铜"},@{@"name":@"铁"}]},@{@"name":@"品类",@"values":@[@{@"name":@"圆形"},@{@"name":@"方形"},@{@"name":@"三角形"}]},@{@"name":@"属性2",@"values":@[@{@"name":@"a"},@{@"name":@"b"}]},@{@"name":@"属性3",@"values":@[@{@"name":@"3a"}]}];
    self.ruleArr = @[@{@"content":@[@{@"name":@"红"},@{@"name":@"铜"},@{@"name":@"三角形"},@{@"name":@"a"},@{@"name":@"3a"}]},@{@"content":@[@{@"name":@"红"},@{@"name":@"铁"},@{@"name":@"圆形"},@{@"name":@"b"},@{@"name":@"3a"}]},@{@"content":@[@{@"name":@"绿"},@{@"name":@"亚克力"},@{@"name":@"方形"},@{@"name":@"b"},@{@"name":@"3a"}]}];
    
}

- (void)selectBtnClick{
    WSSelectView * view = [[WSSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.propertiesArr = self.propertiesArr;
    view.ruleArr = self.ruleArr;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view loadDatas];
}

- (NSArray *)propertiesArr{
    if (!_propertiesArr) {
        _propertiesArr = [NSArray new];
    }
    return _propertiesArr;
}
- (NSArray *)ruleArr{
    if (!_ruleArr) {
        _ruleArr = [NSArray new];
    }
    return _ruleArr;
}
@end
