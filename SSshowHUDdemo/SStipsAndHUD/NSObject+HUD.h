//
//  NSObject+HUD.h
//  SSshowHUDdemo
//
//  Created by F S on 2021/1/26.
//  Copyright © 2021 F S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SStipsAndHUD.h"

NS_ASSUME_NONNULL_BEGIN

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

NS_ASSUME_NONNULL_END
