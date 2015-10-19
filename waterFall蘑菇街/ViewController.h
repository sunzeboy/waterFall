//
//  ViewController.h
//  waterFall蘑菇街
//
//  Created by AiDong on 15/10/16.
//  Copyright © 2015年 AiDong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 颜色
#define YYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define YYColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define YYRandomColor YYColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface ViewController : UIViewController


@end

