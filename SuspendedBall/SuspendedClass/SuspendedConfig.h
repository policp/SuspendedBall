//
//  SuspendedConfig.h
//  KeyWindowAlertShow
//
//  Created by chenpeng on 15/11/5.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SuspendedConfig : NSObject

+ (void)saveSuspendedBallCenter:(CGPoint)center;
+ (CGPoint)achiveSuspendedBallCenter;

@end
