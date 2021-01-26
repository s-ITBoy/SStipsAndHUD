//
//  NSObject+HUD.m
//  SSshowHUDdemo
//
//  Created by F S on 2021/1/26.
//  Copyright © 2021 F S. All rights reserved.
//

#import "NSObject+HUD.h"
#import <objc/runtime.h>

#define KEY_HUD @"dismissHUD"
static char OperationKey;

@implementation NSObject (HUD)

#pragma mark --------- SSshowMsg -------------

- (void)SSshowMsg:(NSString*_Nullable)msg {
    SStipsAndHUD* show = [[SStipsAndHUD alloc] init];
    [show SSshowMsg:msg];
}

- (void)SSshowMsg:(NSString*_Nullable)msg FinishBlock:(void (^)(void))block {
    SStipsAndHUD* show = [[SStipsAndHUD alloc] init];
    [show SSshowMsg:msg FinishBlock:block];
}

- (void)SSshowMsg:(NSString*_Nullable)msg delay:(CGFloat)delay FinishBlock:(void (^)(void))block {
    SStipsAndHUD* show = [[SStipsAndHUD alloc] init];
    [show SSshowMsg:msg delay:delay FinishBlock:block];
}

#pragma mark --------- SSshowHUD -------------

-(void)SSshowLoadingHUD {
    SStipsAndHUD* hud = [self HUD];
    [hud SSshowLoadingSSHUD];
}

- (void)SSshowLoadingHUD:(SSloadingModel)model {
    SStipsAndHUD* hud = [self HUD];
    [hud SSshowLoadingSSHUD:model];
}

- (void)SSdismiss {
    SStipsAndHUD* hud = [self HUD];
    [hud SSdismissLoadingSSHUD];
}

-(void)SSdismissAll {
    SStipsAndHUD* hud = [self HUD];
    [hud SSdismissAllLoading];
}



- (void)setHUD:(SStipsAndHUD*)HUD {
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if(opreations == nil){
        opreations = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &OperationKey, opreations, OBJC_ASSOCIATION_RETAIN);
    }
    [opreations setObject:HUD forKey:KEY_HUD];
}

- (SStipsAndHUD*)HUD {
    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &OperationKey);
    if (opreations == nil) {
        SStipsAndHUD* hud = [[SStipsAndHUD alloc] init];
        [self setHUD:hud];
        return hud;
    }
    SStipsAndHUD* aHUD = [opreations objectForKey:KEY_HUD];
    return aHUD;
}


@end
