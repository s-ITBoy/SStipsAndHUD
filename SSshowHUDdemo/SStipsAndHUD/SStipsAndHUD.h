//
//  SStipsOrHUD.h
//  SSshowHUDdemo
//
//  Created by F S on 2017/11/26.
//  Copyright © 2017 F S. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SSloadingModel) {
    ///系统菊花样式
    SSloadingModelActivityIndicator = 0,
    SSloadingModelActivityIndicatorAndText,
    ///纯文字
    SSloadingModelText,
    ///图片圆环, 当为此模型时，可通过更改名为circle_loading的图片进行更改颜色等
    SSloadingModelImgCircle,
    SSloadingModelImgCircleAndText,
    ///根据path画出的圆环，可根据circleColor属性 设置圆环颜色
    SSloadingModelPathCircle,
    SSloadingModelPathCircleAndText,
    ///自定义
    SSloadingModelCustomize
};

NS_ASSUME_NONNULL_BEGIN

///提示消息文字view
@interface SStipsAndHUD : UIView
///y轴方向偏移量。默认为0（居屏幕中间）正数：往下偏移；负数：往上偏移
@property(nonatomic,assign) CGFloat offset_YY;


///msg显示时的背景色
@property (nonatomic,strong)UIColor* backGroundColor;
///消息的字体颜色
@property (nonatomic,strong)UIColor* msgColor;
///字体
@property (nonatomic,strong)UIFont* font;
///渐变时间
@property (nonatomic,assign)CGFloat duration;
///显示多长时间后隐藏
@property (nonatomic,assign)CGFloat delay;


#pragma mark -------- 提示语 界面点击效果不被遮挡 提示语出现时仍可点击-----------

///此方法不遮盖空白地方的手势操作
- (void)SSmsg:(NSString*_Nullable)msg;


#pragma mark -------- 提示语 界面点击效果被遮挡 提示语出现时不可点击-----------

- (void)SSshowMsg:(NSString*_Nullable)msg;

- (void)SSshowMsg:(NSString*_Nullable)msg FinishBlock:(void (^)(void))block;

- (void)SSshowMsg:(NSString*_Nullable)msg delay:(CGFloat)delay FinishBlock:(void (^)(void))block;


#pragma mark -------- 网络请求时的 加载菊花 -----------

///加载提示框的背景色（默认为：浅灰白色）当设置了次参数值时，注意相应的其它属性值做相应设置
@property(nonatomic,strong) UIColor* bgColor;
///加载菊花的颜色样式。0：白色；非0：黑色（默认为：黑色）
@property(nonatomic,assign) int indicatorColorType;
///加载文本的内容，可不传。默认为：加载中
@property(nonatomic,strong) NSString* loadingText;
///可不传。默认为系统15号字体
@property(nonatomic,strong) UIFont* loadingTextFont;
///可不传。默认为系统黑色
@property(nonatomic,strong) UIColor* loadingTextColor;
///根据path画出的圆环 的颜色 默认黑色
@property(nonatomic,strong) UIColor* circleColor;
///根据path画出的圆环 的宽度 默认 = 4
@property(nonatomic,assign) CGFloat circleWidth;
///当model = SSloadingModelCustomize时，必须指定的参数，且customView为展示的内容
@property(nonatomic,strong) UIView* customView;

///此方法 SSloadingModel 默认为：SSloadingModelActivityIndicator
- (void)SSshowLoadingSSHUD;

///当model = SSloadingModelCustomize时，customView为必传值（即：customView不能为空）
- (void)SSshowLoadingSSHUD:(SSloadingModel)model;

- (void)SSdismissLoadingSSHUD;

- (void)SSdismissAllLoading;

@end

NS_ASSUME_NONNULL_END
