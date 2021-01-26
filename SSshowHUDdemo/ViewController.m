//
//  ViewController.m
//  SSshowHUDdemo
//
//  Created by F S on 2021/1/25.
//  Copyright © 2021 F S. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+HUD.h"

#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

@interface ViewController ()
//@property(nonatomic,strong) UIImageView* firstCircle;
//@property(nonatomic,strong) CAShapeLayer* firstCircleShapeLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 88, 200, 50)];
    [btn setTitle:@"点击按钮进行展示" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtn {
    [self SSshowLoadingHUD:SSloadingModelImgCircleAndText];
    
}


@end
