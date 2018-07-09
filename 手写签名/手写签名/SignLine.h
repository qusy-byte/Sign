//
//  SignLine.h
//  手写签名
//
//  Created by SL on 16/1/22.
//  Copyright © 2016年 SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignLine : UIView

//用来装手指滑动过程中经过的点
@property(nonatomic,strong)NSMutableArray *points;

//用来改变线条颜色
@property(nonatomic,assign)UIColor *lineColor;

@end
