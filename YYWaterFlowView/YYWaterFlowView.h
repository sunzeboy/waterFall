//
//  sunzeboy
//
//  Created by sunzeboy on 15/10/16.
//  Copyright © 2015年 sunzeboy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YYWaterFlowViewMarginType){

    YYWaterFlowViewMarginTypeTop ,    //距离父控件的顶部间距
    YYWaterFlowViewMarginTypeBottom , //距离父控件的底部间距
    YYWaterFlowViewMarginTypeLeft ,   //距离父控件的左边间距
    YYWaterFlowViewMarginTypeRight ,  //距离父控件的右边间距
    YYWaterFlowViewMarginTypeColomn , //cell列间距<水平间距>
    YYWaterFlowViewMarginTypeRow      //cell行间距<纵向间距>
};

@class YYWaterFlowView ;
@class YYWaterFlowViewCell ;

/**
 * 数据源方法
 */
@protocol YYWaterFlowViewDataSource <NSObject>

@required

/**
 * 一共有多少个Cell
 */
- (NSUInteger)numberOfCellsInWaterFlowView:(YYWaterFlowView *)waterFlowView ;

/**
 * 返回index位置对应的cell
 */
- (YYWaterFlowViewCell *)waterFlowView:(YYWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index ;

@optional
/**
 * 一共有多少列
 */
- (NSUInteger)numberOfColumnsInWaterFlowView:(YYWaterFlowView *)waterFlowView ;

@end


/**
 * 代理方法
 */
@protocol YYWaterFlowViewDelegate <UIScrollViewDelegate>

@optional
/**
 * index位置对应的cell的高度
 */
- (CGFloat)waterFlowView:(YYWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index ;

/**
 *  瀑布流控件的边缘设置<上下左右,行间距,列间距>
 */
- (CGFloat)waterFlowView:(YYWaterFlowView *)waterFlowView marginForType:(YYWaterFlowViewMarginType) type ;

/**
 * 选中index位置对应的cell
 */
- (void)waterFlowView:(YYWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index ;

@end

/**
 * 瀑布流控件
 */
@interface YYWaterFlowView : UIScrollView

/**
 * 数据源
 */
@property (nonatomic, weak) id<YYWaterFlowViewDataSource>dataSource ;

/**
 * 代理
 */
@property (nonatomic, weak) id<YYWaterFlowViewDelegate>delegate ;

/**
 * 刷新数据 <只要调用 , 就会向数据源和代理请求数据 , 刷新视图>
 */
- (void)reloadData ;

/**
 *  根据标识去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier ;

/**
 *  返回cell的宽度
 */
- (CGFloat)cellWidth ;

@end
