//
//  WZShowAlertView.m
//  RunLoop
//
//  Created by chenpeng on 15/10/30.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "WZShowAlertView.h"

@interface WZShowAlertView()

@end

@implementation WZShowAlertView

+ (WZShowAlertView *)alertView
{
    static dispatch_once_t token;
    static WZShowAlertView *alertView;
    dispatch_once(&token, ^{
        alertView = [[WZShowAlertView alloc]init];
    });
    return alertView;
}

+ (void)showAlertViewDuration:(NSTimeInterval)time andPosition:(AlertViewPosition)position showMessage:(NSString *)message
{
    [[self alertView]showInView:nil duration:time andPosition:position showMessage:message];
}

+ (void)showAlertViewDuration:(NSTimeInterval)time andMessage:(NSString *)message{
    [[self alertView]showAlertViewDuration:time andMessages:message];
}

- (void)showInView:(UIView *)view duration:(NSTimeInterval)time andPosition:(AlertViewPosition)position showMessage:(NSString *)message
{
    CGPoint center;
    if (position == AlertViewPosition_Top)
    {
        center.x = self.maskWindow.center.x;
        center.y = self.maskWindow.center.y/2;
    }
    else if (position == AlertViewPosition_center)
    {
        center = self.maskWindow.center;
    }
    else if (position == AlertViewPosition_bottom)
    {
        center.x = self.maskWindow.center.x;
        center.y = self.maskWindow.center.y*3/2;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disMiss:) object:nil];
    [self performSelector:@selector(disMiss:) withObject:nil afterDelay:time];
    
    self.time = time;
    [self.maskWindow addSubview:self.messageLabel];
    CGSize size = [self calculateTextMessage:message];
    [self.messageLabel setFrame:CGRectMake(0, 0, size.width+20, size.height+30)];
    self.messageLabel.center = center;
    self.messageLabel.text = message;
    self.messageLabel.layer.cornerRadius = 5.0f;
    self.messageLabel.layer.masksToBounds = YES;
}

- (void)showAlertViewDuration:(NSTimeInterval)time andMessages:(NSString *)string
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alertShowNotifacation:) name:WZAlertViewShowNotifacation object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disMiss:) object:nil];
    [self performSelector:@selector(disMiss:) withObject:nil afterDelay:time];
    
    self.time = time;
    [self.maskWindow addSubview:self.messageLabel];
    CGSize size = [self calculateTextMessage:string];
    [self.messageLabel setFrame:CGRectMake(0, 0, size.width+20, size.height+30)];
    self.messageLabel.center = self.maskWindow.center;
    self.messageLabel.text = string;
    self.messageLabel.layer.cornerRadius = 5.0f;
    self.messageLabel.layer.masksToBounds = YES;
}

- (void)alertShowNotifacation:(NSNotification *)notifa
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(checkMaskWindow:) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)checkMaskWindow:(id)sender
{
    if (self.maskWindow) {
        [self disMiss:nil];
    }
    [self.timer invalidate];
}

- (void)disMiss:(id)sender
{
    [self.messageLabel removeFromSuperview];
    self.maskWindow = nil;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alertHiddenNotifacation:) name:WZAlertViewHiddenNotifacation object:nil];
}

- (void)alertHiddenNotifacation:(NSNotification *)notifa
{
    if (self.maskWindow) {
        self.maskWindow = nil;
    }
    if (self.timer) {
        self.timer = nil;
    }
}

-(void)dealloc{
    self.maskWindow = nil;
    self.timer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WZAlertViewShowNotifacation object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WZAlertViewHiddenNotifacation object:nil];
}

- (CGSize)calculateTextMessage:(NSString *)message
{
    CGSize size = [message boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil].size;
    return size;
}

- (UIWindow *)maskWindow{
    if (!_maskWindow) {
        _maskWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds] ];
        [_maskWindow makeKeyAndVisible];
        [_maskWindow setBackgroundColor:[UIColor clearColor]];
        _maskWindow.windowLevel = UIWindowLevelAlert;
    }
    return _maskWindow;
}

-(UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:39/255.0 alpha:1];
    }
    return _messageLabel;
}

@end
