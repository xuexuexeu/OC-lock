//
//  ViewController.m
//  手势解锁
//
//  Created by qx-002 on 16/11/14.
//  Copyright (c) 2016年 谢凯. All rights reserved.
//

#import "ViewController.h"
#import "CPLockView.h"

@interface ViewController ()<CPLockViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    
    CPLockView *lockView = [[CPLockView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    lockView.backgroundColor = [UIColor clearColor];
    [lockView settingLockLineColorWithColor:[UIColor greenColor] andLineWidth:5];
    lockView.delegate = self;
    [self.view addSubview:lockView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lockViewWithLockView:(CPLockView *)lockView andString:(NSString *)sting{
  
    NSLog(@"手势滑动内容%@",sting);

}
@end
