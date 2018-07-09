//
//  ViewController.m
//  手写签名
//
//  Created by SL on 16/1/22.
//  Copyright © 2016年 SL. All rights reserved.
//

#import "ViewController.h"
#import "SignView.h"
#import "SignLine.h"
#import "UIView+SDAutoLayout.h"

#define BTN_WIDTH [[UIScreen mainScreen] bounds].size.width/3-2


@interface ViewController ()
{
    SignView *_sView;
    SignLine *_line;
    
    NSMutableArray *_reLines;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //构建画布
    _sView = [[SignView alloc] init];
    _sView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_sView];
    //layout
    _sView.sd_layout
    .topSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,60);
    
    [self creatControlButton];
    
    //添加拖拽手势
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(writeSign:)];
    [_sView addGestureRecognizer:gesture];
    
    _reLines = [[NSMutableArray alloc] initWithCapacity:0];
    
}

//构建操作按钮
-(void)creatControlButton
{
    
    UIColor *color = [UIColor orangeColor];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = color;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIButton *revokeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    revokeBtn.backgroundColor = color;
    [revokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
    [revokeBtn addTarget:self action:@selector(revokeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:revokeBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.backgroundColor = color;
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    cancelBtn.sd_layout
    .topSpaceToView(_sView,5)
    .leftSpaceToView(self.view,1)
    .widthIs(BTN_WIDTH)
    .bottomSpaceToView(self.view,1);
    
    revokeBtn.sd_layout
    .topEqualToView(cancelBtn)
    .centerXEqualToView(self.view)
    .centerYEqualToView(cancelBtn)
    .widthIs(BTN_WIDTH)
    .bottomEqualToView(cancelBtn);
    
    doneBtn.sd_layout
    .topEqualToView(revokeBtn)
    .rightSpaceToView(self.view,1)
    .widthIs(BTN_WIDTH)
    .bottomEqualToView(revokeBtn);
}

#define mark ----取消，撤销，确认,btnclick
-(void)cancelButtonClick:(UIButton*)btn
{
    //cancel
    NSLog(@"取消签名,返回到上一页");
}

-(void)revokeButtonClick:(UIButton*)btn
{
    //撤销
    SignLine *line = [_sView.lines lastObject];
    
    if (line)
    {
        //垃圾箱
        [_reLines addObject:line];
        
        [_sView.lines removeObject:line];
        
        [_sView setNeedsDisplay];
    }
}

-(void)doneButtonClick:(UIButton*)btn
{
    //确认签名，保存，发送给服务器
    //1.截图
    UIImage *signImg = [self snapShot:_sView];
    
    //2.保存到本地
    NSString *path = [self imgPath];
    NSLog(@"path === %@",path);
    [UIImagePNGRepresentation(signImg) writeToFile:path atomically:YES];
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(signImg, self, nil, nil);
    
    //3.发送给服务器
}

-(NSString*)imgPath
{
    //图片名可以任取 xxx.png
    return [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/sign.png"];
}

//截图
-(UIImage*)snapShot:(UIView*)signV
{
    UIGraphicsBeginImageContextWithOptions(signV.bounds.size, YES, 0);
    [signV drawViewHierarchyInRect:signV.bounds afterScreenUpdates:YES];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//捕捉拖拽的点，绘制签名
-(void)writeSign:(UIPanGestureRecognizer*)gesture
{
    //1.捕捉点
    CGPoint point = [gesture locationInView:_sView];
    
    //2.转换NSValue
    NSValue *value = [NSValue valueWithCGPoint:point];
    
    //3.每次拖拽，创建出一个线的对象
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        _line = [[SignLine alloc] init];
        //设置线条颜色
        _line.lineColor = [UIColor blackColor];
        
        //装进数组
        [_sView.lines addObject:_line];
    }
    
    //将拖拽的点装进数组
    [_line.points addObject:value];
    
    //刷新
    [_sView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
