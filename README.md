# SStipsAndHUD

Installation

Installation with CocoaPods

when you will use the all Categories:

pod 'SStipsAndHUD'

Usage

import the header file into any class where you wish to make use of the functionality such as

#import <NSObject+HUD.h>



当您不使用cocoapod导入时，也可以直接下载代码导入到您的项目中，只需要将SStipsAndHUD文件夹及其中的内容导入到您的项目中即可,下载的代码中有关于SStipsAndHUD的使用教程demo

NSObject+HUD.h文件中 有公开的方法如下： 

@interface NSObject (HUD)

#pragma mark --------- SSshowMsg -------------

///msg：提示语
- (void)SSshowMsg:(NSString*_Nullable)msg;
///msg：提示语；block：提示语结束后的回调
- (void)SSshowMsg:(NSString*_Nullable)msg FinishBlock:(void (^)(void))block;
///msg：提示语；delay：延迟时间；block：提示语结束后的回调
- (void)SSshowMsg:(NSString*_Nullable)msg delay:(CGFloat)delay FinishBlock:(void (^)(void))block;

#pragma mark --------- SSshowHUD -------------

///此方法 默认显示菊花
- (void)SSshowLoadingHUD;

- (void)SSshowLoadingHUD:(SSloadingModel)model;

- (void)SSdismiss;

- (void)SSdismissAll;

@end
