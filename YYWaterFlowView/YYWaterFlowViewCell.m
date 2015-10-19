//
//  YYWaterFlowViewCell.m
//  waterFall蘑菇街
//
//  Created by AiDong on 15/10/16.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import "YYWaterFlowViewCell.h"

@implementation YYWaterFlowViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self ;
}

-(id)initWithIdentifier:(NSString *)indentifier
{
    self = [[YYWaterFlowViewCell alloc] init];
    self.identifier = _identifier ;
    
    return self ;
}

@end
