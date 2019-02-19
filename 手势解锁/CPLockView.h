//
//  CPLockView.h
//  手势解锁
//
//  Created by qx-002 on 16/11/14.
//  Copyright (c) 2016年 谢凯. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CPLockView;
@protocol CPLockViewDelegate <NSObject>

-(void)lockViewWithLockView:(CPLockView *)lockView andString:(NSString *)sting;

@end
@interface CPLockView : UIView

@property(nonatomic ,strong)id<CPLockViewDelegate>delegate;

//设置线的颜色和线的宽度
-(void)settingLockLineColorWithColor:(UIColor*)lineColor andLineWidth:(CGFloat)lineWidth;
@end
