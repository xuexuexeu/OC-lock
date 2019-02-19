//
//  CPLockView.m
//  手势解锁
//
//  Created by qx-002 on 16/11/14.
//  Copyright (c) 2016年 谢凯. All rights reserved.
//

#import "CPLockView.h"
@interface CPLockView()
@property(nonatomic ,strong)NSMutableArray *lineData;

@property(nonatomic ,assign)CGPoint currentPoint;
@property(strong,nonatomic)UIColor *lineColor;
@property(assign,nonatomic)CGFloat lineWidth;
@end

@implementation CPLockView


//纯代码创建
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"zai");
        [self setBtn];
    }
    
    return self;
    
}

////storyboard创建
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//
//    if (self = [super initWithCoder:aDecoder]) {
//        NSLog(@"aDecoder");
//        [self setBtn];
//    }
//    return self;
//}
//设置线的颜色和线的宽度
-(void)settingLockLineColorWithColor:(UIColor*)lineColor andLineWidth:(CGFloat)lineWidth{
    self.lineColor = lineColor;
    self.lineWidth = lineWidth;
}
-(void)setBtn{
    
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateHighlighted];
        
        // 按钮可以响应事件，所以 它的父控件就不能触发，如果按钮 不响应事件，它就会把这个 给你父控件来相应，如果你父控件不能相应，它会让你得父控件的父控件来相应
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        //关闭按钮的响应事件
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
    }
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger btnCount = self.subviews.count;
    NSLog(@"%ld",(long)btnCount);
    NSInteger num = 3;
    CGFloat btnW = 74;
    CGFloat btnH = 74;
    
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn = self.subviews[i];
        
        NSInteger col = i % num;
        NSInteger row = i / num;
        
        CGFloat margin = (self.bounds.size.width - btnW * num)/(num + 1);
        
        CGFloat btnX = margin + (btnW + margin) * col;
        CGFloat btnY = (btnH +margin) * row;
        
        btn.frame = CGRectMake(btnX, btnY+50, btnW, btnH);
        
    }
    
}
-(NSMutableArray *)lineData{
    if (_lineData == nil) {
        _lineData = [NSMutableArray array];
    }
    return _lineData;
}

#pragma mark  私有计算方法  获取touch移动点的坐标
-(CGPoint)pointWithTouches :(NSSet *)touches{
  UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.currentPoint = CGPointZero;
    CGPoint point = [self pointWithTouches:touches];
//    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    // 判断 点击的点 是否在 按钮里面，如果在 按钮里面 就 设置 高亮状态
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;
//             [path moveToPoint:btn.center];
            [self.lineData addObject:btn];
        }
    }

   
//    [self.lineData addObject:path];
    [self setNeedsDisplay];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self pointWithTouches:touches];

    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            btn.selected = YES;

              //不能够让 已经 在 连线数组里面的 按钮 重新再链接
            if (![self.lineData containsObject:btn])
             [self.lineData addObject:btn];
            
        }
        else{
            self.currentPoint = point;
        
        }
    }

    [self setNeedsDisplay];
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   
    NSMutableString *str = [NSMutableString string];
    for (UIButton *btn in self.lineData) {
        [str appendFormat:@"%ld",(long)btn.tag];
    }
    NSLog(@"%@",str);
    if ([self.delegate respondsToSelector:@selector(lockViewWithLockView:andString:)]) {
        [self.delegate lockViewWithLockView:self andString:str];
    }
    for (UIButton *btn in self.lineData) {
        btn.selected = NO;
    }
    [self.lineData removeAllObjects];
    [self setNeedsDisplay];
}

//开始绘制
-(void)drawRect:(CGRect)rect{
    UIBezierPath *path = [[UIBezierPath alloc]init];
    for (int i = 0; i < self.lineData.count; i++) {
        UIButton *btn = self.lineData[i];
        
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else{
            [path addLineToPoint:btn.center];
        }
    }
   if (!CGPointEqualToPoint(self.currentPoint, CGPointZero) && self.lineData.count != 0)[path addLineToPoint:self.currentPoint];
    
    path.lineWidth = !self.lineWidth?10:self.lineWidth;
    path.lineJoinStyle =  kCGLineJoinRound;
    if (!self.lineColor) {
        [[UIColor yellowColor] setStroke];
    }else{
        [self.lineColor setStroke];
    }
    [path stroke];
  
}

// 1. 让 按钮不能交互，让自定义view能够相应

// 2. 给 Path 添加 按钮 中心点

@end
