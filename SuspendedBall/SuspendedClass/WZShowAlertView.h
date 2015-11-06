//
//  WZShowAlertView.h
//  RunLoop
//
//  Created by chenpeng on 15/10/30.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlertViewPosition)
{
    AlertViewPosition_Top ,
    AlertViewPosition_center ,
    AlertViewPosition_bottom 
};

static  NSString  *const WZAlertViewShowNotifacation = @"WZAlertViewShowNotifacation";
static  NSString  *const WZAlertViewHiddenNotifacation = @"WZAlertViewHiddenNotifacation";

@interface WZShowAlertView : UIView
@property (strong, nonatomic)UIWindow *maskWindow;
@property (strong, nonatomic)UILabel  *messageLabel;
@property (strong, nonatomic)NSTimer *timer;
@property (assign, nonatomic)NSTimeInterval time;
@property (assign, nonatomic)AlertViewPosition posittion;
+(void)showAlertViewDuration:(NSTimeInterval)time andPosition:(AlertViewPosition)position showMessage:(NSString *)message;
+(void)showAlertViewDuration:(NSTimeInterval)time andMessage:(NSString *)message;
@end
