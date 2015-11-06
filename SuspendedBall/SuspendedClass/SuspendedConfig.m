//
//  SuspendedConfig.m
//  KeyWindowAlertShow
//
//  Created by chenpeng on 15/11/5.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "SuspendedConfig.h"
#define BallX     @"ballX"
#define BallY     @"ballY"
@implementation SuspendedConfig

+ (void)saveSuspendedBallCenter:(CGPoint)center
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ballX = [NSString stringWithFormat:@"%f",center.x];
    NSString *ballY = [NSString stringWithFormat:@"%f",center.y];
    [defaults setObject:ballX forKey:BallX];
    [defaults setObject:ballY forKey:BallY];
    [defaults synchronize];
}

+ (CGPoint)achiveSuspendedBallCenter
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGPoint center;
    center.x = [[defaults objectForKey:BallX] floatValue];
    center.y = [[defaults objectForKey:BallY] floatValue];
    if (![defaults objectForKey:BallX]||![defaults objectForKey:BallY]) {
        center.x = 30.0f;
        center.y = 200.0f;
    }
    return center;
}

@end
