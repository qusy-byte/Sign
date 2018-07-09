//
//  SignLine.m
//  手写签名
//
//  Created by SL on 16/1/22.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "SignLine.h"

@implementation SignLine

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _points = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
