//
//  SignView.m
//  手写签名
//
//  Created by SL on 16/1/22.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SignView.h"
#import "SignLine.h"

@implementation SignView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _lines = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    
    return self;
}



//构建签名画板，进行签名
- (void)drawRect:(CGRect)rect
{
    /*
     
     手动划线的步骤
     
     *** 每一次重新点击屏幕对应的先要创建出来一个装线段的数组
     
     1.收集所有的点>>>装到(线段)数组里面
     2.根据收集到的点 创建画布 指定起点>>>终点
     3.构建出来对应的线。
     4.调用setNeedsDisplays方法刷新当前的view
     */
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    \
    //遍历装SignLine得数组
    [_lines enumerateObjectsUsingBlock:^(SignLine *obj, NSUInteger idx, BOOL *stop) {
        
        CGContextSetStrokeColorWithColor(context, [obj.lineColor CGColor]);
        
        //遍历一个线上的所有点
        [obj.points enumerateObjectsUsingBlock:^(NSValue *value, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //拿到所有的点
            CGPoint point = [value CGPointValue];
            
            if (idx == 0)
            {
                //指定画笔到对应的位置
                CGContextMoveToPoint(context, point.x, point.y);
            }
            else
            {
                //添加线
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }];
        
        //保证每一次绘制出来一个单独的线
        CGContextStrokePath(context);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
