//
//  YYWaterFlowView.m
//  waterFall蘑菇街
//
//  Created by AiDong on 15/10/16.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "YYWaterFlowView.h"
#import "YYWaterFlowViewCell.h"

#define YYWaterFlowViewDefaultCellHeight 70.f
#define YYWaterFlowViewDefaultColomns 3
#define YYWaterFlowViewDefaultMargin 8.f


@interface YYWaterFlowView ()
/**
 *  所有cell的frame的数组
 */
@property (nonatomic, strong) NSMutableArray *cellFrames ;
/**
 *  正在展示的cell
 */
@property (nonatomic, strong) NSMutableDictionary *dispalyingCells ;
/**
 *  缓存池 (用Set , 存放离开屏幕的cell)
 */
@property (nonatomic, strong) NSMutableSet *reusableCells ;

@end

@implementation YYWaterFlowView

#pragma mark --- 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellFrames = [NSMutableArray array] ;
        self.dispalyingCells = [NSMutableDictionary dictionary];
        self.reusableCells = [NSMutableSet set];
    }
    return self ;
}
/**
 *  即将被添加到父视图的时候调用
 */
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}

#pragma mark --- 公共接口

/**
 * 返回cell宽度
 */
- (CGFloat)cellWidth
{
    //总列数
    int numberOfColomns = (unsigned)[self numberOfColomns];
    
    CGFloat leftMargin = [self marginForType:YYWaterFlowViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:YYWaterFlowViewMarginTypeRight];
    CGFloat colomnMargin = [self marginForType:YYWaterFlowViewMarginTypeColomn];
    
    return (self.frame.size.width - leftMargin - rightMargin - (numberOfColomns-1)*colomnMargin)/numberOfColomns ;
}
/**
 * 刷新数据
 */
- (void)reloadData
{
    //cell总数
    int numberOfCells = (unsigned)[self.dataSource numberOfCellsInWaterFlowView:self] ;
    
    //总列数
    int numberOfColomns = (unsigned)[self numberOfColomns];
    
    CGFloat topMargin = [self marginForType:YYWaterFlowViewMarginTypeTop];
    CGFloat bottomMargin = [self marginForType:YYWaterFlowViewMarginTypeBottom];
    CGFloat leftMargin = [self marginForType:YYWaterFlowViewMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:YYWaterFlowViewMarginTypeRight];
    CGFloat colomnMargin = [self marginForType:YYWaterFlowViewMarginTypeColomn];
    CGFloat rowMargin = [self marginForType:YYWaterFlowViewMarginTypeRow];
    
    
    //cell的宽度
    CGFloat cell_width = [self cellWidth];
    
    //用一个C语言的数组存放所有列的最大Y值
    CGFloat maxYOfColomns[numberOfColomns] ;
    for (int i = 0; i < numberOfColomns; i++) {
        maxYOfColomns[i] = 0.f ;
    }
    
    //计算所有cell的frame
    for ( int i = 0; i < numberOfCells; i++) {
        
        //计算cell处在第几列(最短的那一列)
        NSUInteger cellColomn = 0 ;
        //cell所处的那一列(最短的那一列)的最大的Y值
        CGFloat maxYOfCellColomn = maxYOfColomns[cellColomn] ;
        //计算最短的那一列
        for (int j = 1 ; j < numberOfColomns; j++) {
            if (maxYOfColomns[j] < maxYOfCellColomn) {
                cellColomn = j ;
                maxYOfCellColomn = maxYOfColomns[j] ;
            }
        }
        
        // cell的高度
        CGFloat cell_height = [self cellHeightAtIndex:i];
        
        //cell的位置
        CGFloat cell_X = leftMargin + cellColomn*(cell_width + colomnMargin) ;
        CGFloat cell_Y = 0.f ;
        if (maxYOfCellColomn == 0.f) { //如果在首行的话Y就等于topMargin
            cell_Y = topMargin ;
        }else{                         //不在首行那就是maxYOfCellColomn加上行间距
            cell_Y = maxYOfCellColomn + rowMargin ;
        }
        
        //把frame添加到数组中
        CGRect cellFrame = CGRectMake(cell_X, cell_Y, cell_width, cell_height) ;
        [_cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        //更新最短那一列的最大的Y值
        maxYOfColomns[cellColomn] = CGRectGetMaxY(cellFrame) ;
    }
    
    //设置contentSize , 否则不能滚动
    CGFloat contentHeight = maxYOfColomns[0] ;
    for (int i = 0; i < numberOfColomns; i++) {
        if (maxYOfColomns[i] > contentHeight) {
            contentHeight = maxYOfColomns[i] ;
        }
    }
    contentHeight += bottomMargin ;
    self.contentSize = CGSizeMake(self.frame.size.width, contentHeight) ;
}
/**
 *  当UIScrollView滚动的时候会调用这个方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews] ;
    
    //相数据源索要对应位置的cell
    NSUInteger numberOfCells = self.cellFrames.count ;
    for (int i = 0; i < numberOfCells ; i++) {
        //取出cell的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue] ;
        
        //优先从字典里面取cell
        YYWaterFlowViewCell *cell = self.dispalyingCells[@(i)] ;
        
        //判断i位置的对应的frame在不在屏幕上<是否可见>
        if ([self isOnScreen:cellFrame]) {  // 在屏幕上
            
            if (cell == nil) {
                cell = [self.dataSource waterFlowView:self cellAtIndex:i] ;
                cell.frame = cellFrame ;
                [self addSubview:cell];
                
                //存放到字典中
                self.dispalyingCells[@(i)] = cell ;
            }
            
        }else{                              // 不在屏幕上
        
            if(cell){
                // 这个cell存在,但不在屏幕上 , 就从scrollView上移除,存放到缓存池
                [cell removeFromSuperview];
                [self.dispalyingCells removeObjectForKey:@(i)];
                
                // 存放进缓存池
                [self.reusableCells addObject:cell];
            }
        }
    }
}

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block YYWaterFlowViewCell *reuseCell = nil ;
    
    //遍历可复用的cell集合查找可以复用的cell
    [self.reusableCells enumerateObjectsUsingBlock:^(YYWaterFlowViewCell *cell, BOOL * _Nonnull stop) {
        
        if ([cell.identifier isEqualToString:identifier]) {
            reuseCell = cell ;
            *stop = YES ;
        }
    }];
    
    // 从缓存池中移除
    if (reuseCell) {
        [self.reusableCells removeObject:reuseCell];
    }
    
    return reuseCell ;
}

#pragma mark --- 私有方法
/**
 *  判断一个frame是否显示在屏幕上
 */
- (BOOL)isOnScreen:(CGRect)frame
{
    //这两个条件都满足的话那就不在屏幕上 , 否则就在屏幕上
    return (CGRectGetMaxY(frame) > self.contentOffset.y) &&
           (CGRectGetMinY(frame) < self.contentOffset.y + self.frame.size.height);
}
/**
 *  返回waterFlowView的各种间距<顶部,底部,左边,右边间距以及列间距和行间距>
 *
 *  @param type 间距类型
 *
 *  @return 间距大小
 */
- (CGFloat)marginForType:(YYWaterFlowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:marginForType:)]) {
        return [self.delegate waterFlowView:self marginForType:type];
    }else{
        return YYWaterFlowViewDefaultMargin ;
    }
}

/**
 * 返回有多少列cell , 默认3列
 */
- (NSUInteger)numberOfColomns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterFlowView:)]) {
        return [self.dataSource numberOfColumnsInWaterFlowView:self];
    }else{
        return YYWaterFlowViewDefaultColomns ;
    }
}

/**
 * 返回每一个cell高度 , 默认70.f
 */
- (CGFloat)cellHeightAtIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:heightAtIndex:)]){
        return [self.delegate waterFlowView:self heightAtIndex:index] ;
    }
    else{
        return YYWaterFlowViewDefaultCellHeight ;
    }
}

#pragma mark --- 点击事件处理

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterFlowView:didSelectAtIndex:)]) return ;
    
    //获得触摸点
    UITouch *touch = [touches anyObject] ;
    
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectedIndex = nil ;
    
    [self.dispalyingCells enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, YYWaterFlowViewCell *cell, BOOL * _Nonnull stop) {
        
        if (CGRectContainsPoint(cell.frame, point)) {
            selectedIndex = key ;
            *stop = YES ;
        }
    }] ;
    
    if (selectedIndex) {
        [self.delegate waterFlowView:self didSelectAtIndex:[selectedIndex unsignedIntegerValue]] ;
    }
}

@end
