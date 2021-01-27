//
//  SStipsOrHUD.m
//  SSshowHUDdemo
//
//  Created by F S on 2017/11/26.
//  Copyright © 2017 F S. All rights reserved.
//

#import "SStipsAndHUD.h"
#import <objc/runtime.h>

#define Scale  [[UIScreen mainScreen] bounds].size.width/375
#define ssscale(x)   x*Scale

@interface SStipsAndHUD () {
    UILabel* _label;
}
@property(nonatomic,assign) SSloadingModel model;
///加载菊花的父视图 / 背景视图
@property(nonatomic,strong) UIView* bgView;
///
@property(nonatomic,strong) UIActivityIndicatorView* indicatorView;
@property(nonatomic,strong) UILabel* loadingLab;
@property(nonatomic,strong) UIImageView* circleImgV;
@property(nonatomic,strong) NSTimer* timer;

@property(nonatomic,copy) void (^SScancelBlock) (void);
@end

@implementation SStipsAndHUD

#pragma mark ------- 懒加载 ----------
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ssscale(80), ssscale(80))];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.6f];
        _bgView.layer.cornerRadius = ssscale(5);
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        if (@available(iOS 13.0, *)) {
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        }else {
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        _indicatorView.transform = CGAffineTransformMakeScale(1.8, 1.8);
    }
    return _indicatorView;
}
- (UILabel *)loadingLab {
    if (!_loadingLab) {
        _loadingLab = [[UILabel alloc] init];
        _loadingLab.textAlignment = NSTextAlignmentCenter;
        _loadingLab.font = [UIFont systemFontOfSize:15];
        _loadingLab.text = @"加载中";
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_loadingLab addGestureRecognizer:tap];
    }
    return _loadingLab;
}
- (UIImageView *)circleImgV {
    if (!_circleImgV) {
        _circleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ssscale(32), ssscale(32))];
        if (_model == SSloadingModelImgCircle || _model == SSloadingModelImgCircleAndText) {
            _circleImgV.image = [UIImage imageNamed:@"SStipsAndHUD.bundle/circle_loading"];
        }else {
            _circleImgV.image = [self drawCircleWithRadius:ssscale(32) width:self.circleWidth > 0 ? self.circleWidth : ssscale(4) color:self.circleColor ? self.circleColor : [UIColor blackColor]];
        }
        
        _circleImgV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _circleImgV;
}


//FIXME:----------
- (instancetype)init {
    if (self = [super init]) {
        _backGroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _font = [UIFont systemFontOfSize:12];
        _msgColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        _offset_YY = 0;
        _duration = 0.5;
        _delay = 0.5;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _backGroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _font = [UIFont systemFontOfSize:12];
        _msgColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
        _offset_YY = 0;
        _duration = 0.5;
        _delay = 0.5;
    }
    return self;
}

- (void)setSubWith:(NSString*)msg canClick:(BOOL)canClick {
    self.layer.cornerRadius = 5;
    self.tag = 10010101;
    
    for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 10010101) {
            [view removeFromSuperview];
        }
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UILabel* lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 2;
    lab.font = _font;
    lab.textColor = _msgColor;
    lab.text = msg;
    [self addSubview:lab];
    _label = lab;
    
    if (canClick) {
        self.backgroundColor = _backGroundColor;
        self.alpha = 0;
        CGSize size = [msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_font} context:nil].size;
            if (size.height > 20) {
                self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, size.height+10);
                lab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, size.height);
                
            }else {
                self.frame = CGRectMake(0, 0, size.width+10, size.height+10);
                lab.frame = CGRectMake(0, 0, size.width+10, size.height+10);
            }
//        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2 + _offset_YY);
    }else {
        lab.alpha = 0;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor clearColor];
        lab.backgroundColor = _backGroundColor;

        CGSize size = [msg boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 200) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_font} context:nil].size;
        if (size.height > 20) {
//            self.frame = CGRectMake(0, 0, ScreenWidth, size.height+10);
            lab.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, size.height);

        }else {
//            self.frame = CGRectMake(0, 0, size.width+10, size.height+10);
            lab.frame = CGRectMake(0, 0, size.width+10, size.height+10);
        }
//        lab.center = self.center;
        lab.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + _offset_YY);
    }
}

#pragma mark -------- 提示语 界面点击效果不被遮挡 提示语出现时仍可点击-----------

///此方法不遮盖空白地方的手势操作
- (void)SSmsg:(NSString*_Nullable)msg {
    if (![self isEmptyStr:msg]) {
        [self setSubWith:msg canClick:YES];
        
        [UIView animateWithDuration:_duration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [self performBlock:^{
                    [UIView animateWithDuration:self->_duration animations:^{
                        self.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                    }];
                    
                } AfterDelay:self->_delay];
            }else {
                [self removeFromSuperview];
            }
        }];
    }
}


#pragma mark -------- 提示语 界面点击效果被遮挡 提示语出现时不可点击-----------

- (void)SSshowMsg:(NSString*_Nullable)msg {
    if (![self isEmptyStr:msg]) {
        [self setSubWith:msg canClick:NO];
        
        [UIView animateWithDuration:_duration animations:^{
//            self.alpha = 1;
            self->_label.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [self performBlock:^{
                    [UIView animateWithDuration:self->_duration animations:^{
//                        self.alpha = 0;
                        self->_label.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                    }];
                    
                } AfterDelay:self->_delay];
            }else {
                [self removeFromSuperview];
            }
        }];
    }
}

- (void)SSshowMsg:(NSString*_Nullable)msg FinishBlock:(void (^)(void))block {
    if (![self isEmptyStr:msg]) {
        [self setSubWith:msg canClick:NO];
        
        [UIView animateWithDuration:_duration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [self performBlock:^{
                    [UIView animateWithDuration:self->_duration animations:^{
                        self.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                        block();
                    }];
                    
                } AfterDelay:self->_delay];
            }
        }];
    }
}

- (void)SSshowMsg:(NSString*_Nullable)msg delay:(CGFloat)delay FinishBlock:(void (^)(void))block {
    if (![self isEmptyStr:msg]) {
        [self setSubWith:msg canClick:NO];
        [UIView animateWithDuration:_duration animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [self performBlock:^{
                    [UIView animateWithDuration:self->_duration animations:^{
                        self.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                        block();
                    }];
                    
                } AfterDelay:delay];
            }
        }];
    }
}

- (void)performBlock:(void(^)(void))block AfterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(fireBlock:) withObject:block afterDelay:delay];
}

- (void)fireBlock:(void (^)(void))block {
    block();
}

#pragma mark -------- 网络请求时的 加载菊花 -----------

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bgView.backgroundColor = bgColor;
}

- (void)setIndicatorColorType:(int)indicatorColorType {
    _indicatorColorType = indicatorColorType;
    if (indicatorColorType == 0) {
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }else {
        if (@available(iOS 13.0, *)) {
            self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        }else {
            self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        }
    }
}

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = loadingText;
    self.loadingLab.text = loadingText;
}

- (void)setLoadingTextFont:(UIFont *)loadingTextFont {
    _loadingTextFont = loadingTextFont;
    self.loadingLab.font = loadingTextFont;
}

- (void)setLoadingTextColor:(UIColor *)loadingTextColor {
    _loadingTextColor = loadingTextColor;
    self.loadingLab.textColor = loadingTextColor;
}

- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
}

- (void)setCircleWidth:(CGFloat)circleWidth {
    _circleWidth = circleWidth;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
}

- (void)setSubWithModel:(SSloadingModel)model {
    self.backgroundColor = [UIColor clearColor];
    self.tag = 10010101;
    
    for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 10010101) {
            [view removeFromSuperview];
        }
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self addSubview:self.bgView];
    
    switch (model) {
        case SSloadingModelActivityIndicator: {
            [self setSubV:self.indicatorView];
            [self.indicatorView startAnimating];
        }
            break;
        case SSloadingModelActivityIndicatorAndText: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(100), width);
            
            [self setSubViews:self.indicatorView and:self.loadingLab width:width cancel:NO];
            [self.indicatorView startAnimating];
        }
            break;
        case SSloadingModelActivityIndicatorAndCancelBtn: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(100), width);
            
            [self setSubViews:self.indicatorView and:self.loadingLab width:width cancel:YES];
            [self.indicatorView startAnimating];
        }
            break;
        case SSloadingModelText: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(80), width);
            
            self.bgView.frame = CGRectMake(0, 0, width, width);
            self.loadingLab.frame = CGRectMake(0, 0, width, width);
            [self setSubV:self.loadingLab];
        }
            break;
        case SSloadingModelImgCircle: {
            [self setSubV:self.circleImgV];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];;
            }
        }
            break;
        case SSloadingModelImgCircleAndText: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(100), width);
            
            [self setSubViews:self.circleImgV and:self.loadingLab width:width cancel:NO];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];;
            }
        }
                break;
        case SSloadingModelImgCircleAndCancelBtn: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(100), width);
            
            [self setSubViews:self.circleImgV and:self.loadingLab width:width cancel:YES];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];;
            }
        }
            break;
        case SSloadingModelPathCircle: {
            
            [self setSubV:self.circleImgV];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];;
            }
        }
            break;
        case SSloadingModelPathCircleAndText: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(100), width);
            
            [self setSubViews:self.circleImgV and:self.loadingLab width:width cancel:NO];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];;
            }
        }
            break;
        case SSloadingModelPathCircleAndCancelBtn: {
            CGFloat width = [self.loadingLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.loadingLab.font,NSFontAttributeName, nil]].width + ssscale(20);
            width = MAX(ssscale(100), width);
            
            [self setSubViews:self.circleImgV and:self.loadingLab width:width cancel:YES];
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runCircle) userInfo:nil repeats:YES];;
            }
        }
            break;
        case SSloadingModelCustomize: {
            if (self.customView) {
                CGRect frame = CGRectMake(0, 0, self.customView.frame.size.width, self.customView.frame.size.height);
                self.bgView.frame = frame;
                [self setSubV:self.customView];
            }else {
                self.bgView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + _offset_YY);
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setSubV:(UIView*)view {
    self.bgView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + _offset_YY);
    
    [self.bgView addSubview:view];
    view.center = CGPointMake(self.bgView.bounds.size.width/2, self.bgView.bounds.size.height/2);
}

- (void)setSubViews:(UIView*)upView and:(UIView*_Nullable)downView width:(CGFloat)width cancel:(BOOL)cancel {
    self.bgView.frame = CGRectMake(0, 0, width, width);
    self.bgView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + _offset_YY);
    
    [self.bgView addSubview:upView];
    upView.center = CGPointMake(self.bgView.bounds.size.width/2, self.bgView.bounds.size.height/2 - ssscale(15));
    
    if (downView != nil) {
        [self.bgView addSubview:downView];
        downView.frame = CGRectMake(0, 0, cancel ? width-ssscale(20) : width, ssscale(20));
        downView.center = CGPointMake(self.bgView.bounds.size.width/2, self.bgView.bounds.size.height/2 + ssscale(25));
        downView.userInteractionEnabled = cancel;
        if (cancel) {
            downView.layer.borderWidth = 0.5;
            downView.layer.borderColor = self.loadingTextColor ? self.loadingTextColor.CGColor : [UIColor blackColor].CGColor;
            downView.layer.cornerRadius = downView.frame.size.height / 2;
            downView.layer.masksToBounds = YES;
            
        }
    }
    
}

- (void)SSshowLoadingSSHUD {
    [self SSshowLoadingSSHUD:0];
}

- (void)SSshowLoadingSSHUD:(SSloadingModel)model {
    _model = model;
    [self setSubWithModel:model];
}

- (void)SSdismissLoadingSSHUD {
    if (_model == SSloadingModelActivityIndicator || _model == SSloadingModelActivityIndicatorAndText) {
        [self.indicatorView stopAnimating];
    }
    if (_model == SSloadingModelImgCircle || _model == SSloadingModelImgCircleAndText || _model == SSloadingModelPathCircle || _model == SSloadingModelPathCircleAndText) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    [self removeFromSuperview];
}

- (void)SSdismissLoadingSSHUD:(void (^)(void))cancelBlock {
    _SScancelBlock = cancelBlock;
}

- (void)SSdismissAllLoading {
    for (UIView* view in [UIApplication sharedApplication].keyWindow.subviews) {
        if (view.tag == 10010101) {
            SStipsAndHUD* showView = (SStipsAndHUD*)view;
            if (showView.model == SSloadingModelActivityIndicator || showView.model == SSloadingModelActivityIndicatorAndText) {
                [self.indicatorView stopAnimating];
            }
            if (showView.model == SSloadingModelImgCircle || showView.model == SSloadingModelImgCircleAndText) {
                if (self.timer) {
                    [self.timer invalidate];
                    self.timer = nil;
                }
            }
            [view removeFromSuperview];
        }
    }
}

///计时器Timer的方法
- (void)runCircle {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.circleImgV.transform = CGAffineTransformRotate(self.circleImgV.transform, 0.0006);
    });
}

- (void)tap {
    [self SSdismissLoadingSSHUD];
}

///画圆环图片
- (UIImage*)drawCircleWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*radius, 2*radius),NO,[UIScreen mainScreen].scale);  //开始画线
    //生成圆环上部分
    UIImage *upperImage = [self drawgradientCircleWithRadius:radius width:width color:color upper:YES];
    //生成圆环下部分
    UIImage *image = [self drawgradientCircleWithRadius:radius width:width color:color upper:NO];
    //合并成一个圆环
    [upperImage drawInRect:CGRectMake(0, 0, radius*2, radius)];
    [image drawInRect:CGRectMake(0, radius, radius*2, radius)];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage*)drawgradientCircleWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color upper:(BOOL)upper {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*radius, radius),NO,[UIScreen mainScreen].scale);  //开始画线
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, width);
    //绘制半圆环
    if (upper) {
//        CGContextAddArc(context, radius, radius, radius-width*0.5, M_PI, 2*M_PI, 0);
        CGContextAddArc(context, radius, radius, radius-width*0.5, M_PI, 2*M_PI, 0);
    }else{
        CGContextAddArc(context, radius, 0, radius-width*0.5, 0, M_PI, 0);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colorArray = [NSMutableArray array];
    [colorArray addObject:(id)[color colorWithAlphaComponent:0].CGColor];
    [colorArray addObject:(id)[color colorWithAlphaComponent:0.5].CGColor];
    [colorArray addObject:(id)[color colorWithAlphaComponent:1].CGColor];
    
    //null标识渐变色均匀分布
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArray, NULL);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpace);
    CGContextReplacePathWithStrokedPath(context);
    CGContextClip(context);
    // 4. 用渐变色填充
    //圆环是逆时针分布，所以上半部分圆环渐变色从-2*radius到28radius
    //下半部分圆环从2*radius到-2radius
    if (upper) {
        CGContextDrawLinearGradient(context, gradientRef, CGPointMake(-radius*2, radius), CGPointMake(radius*2, radius), 0);
    }else{
        CGContextDrawLinearGradient(context, gradientRef, CGPointMake(radius*2, radius), CGPointMake(-radius*2, radius), 0);
    }
    // 释放渐变色
    CGGradientRelease(gradientRef);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    //拉伸当前图像
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return theImage;
}

- (BOOL)isEmptyStr:(id _Nullable)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        if (![obj length] || obj == nil || obj == NULL || [obj isKindOfClass:[NSNull class]] || [[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [obj isEqualToString:@"(null)"] || [obj stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            return YES;
        }
        return NO;
    }else {
        return YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

