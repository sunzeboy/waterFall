//
//  ViewController.m
//  waterFall蘑菇街
//
//  Created by AiDong on 15/10/16.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "ViewController.h"
#import "YYWaterFlowView.h"
#import "YYWaterFlowViewCell.h"




@interface ViewController ()<YYWaterFlowViewDataSource ,
                             YYWaterFlowViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    YYWaterFlowView *waterFlowView = [[YYWaterFlowView alloc] init];
    waterFlowView.frame = self.view.bounds ;
    waterFlowView.delegate = self ;
    waterFlowView.dataSource = self ;
    [self.view addSubview:waterFlowView];
}

#pragma mark - 数据源方法

- (NSUInteger)numberOfCellsInWaterFlowView:(YYWaterFlowView *)waterFlowView
{
    return 100 ;
}

- (NSUInteger)numberOfColumnsInWaterFlowView:(YYWaterFlowView *)waterFlowView
{
    return 3 ;
}

- (YYWaterFlowViewCell *)waterFlowView:(YYWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index
{
    static NSString *ID = @"cell";
    YYWaterFlowViewCell *cell = [waterFlowView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[YYWaterFlowViewCell alloc] initWithIdentifier:ID];
        cell.backgroundColor = YYRandomColor ;
    }
    
    return cell ;
}

#pragma mark - 代理方法

- (CGFloat)waterFlowView:(YYWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index
{
    switch (index % 3) {
        case 0: return 160.f ;
        case 1: return 200.f ;
        case 2: return 180.f ;
        default: return 120 ;
            break;
    }
}

- (CGFloat)waterFlowView:(YYWaterFlowView *)waterFlowView marginForType:(YYWaterFlowViewMarginType)type
{
    switch (type) {
        case YYWaterFlowViewMarginTypeTop:
        case YYWaterFlowViewMarginTypeBottom:
        case YYWaterFlowViewMarginTypeLeft:
        case YYWaterFlowViewMarginTypeRight:
            return 10.f ;
            
        default:return 5.f ;
            break;
    }
}

- (void)waterFlowView:(YYWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"点了第%lu个cell",(unsigned long)index) ;
}

@end
