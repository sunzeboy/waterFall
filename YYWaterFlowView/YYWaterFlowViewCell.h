//
//  YYWaterFlowViewCell.h
//  waterFall蘑菇街
//
//  Created by AiDong on 15/10/16.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYWaterFlowViewCell : UIView
/**
 *  cell重用的标识
 */
@property (nonatomic, copy) NSString *identifier ;

/**
 *  快速构造方法
 *
 *  @param indentifier cell重用的标识
 *
 *  @return 返回一个YYWaterFlowViewCell
 */
- (id)initWithIdentifier:(NSString *)indentifier ;

@end
