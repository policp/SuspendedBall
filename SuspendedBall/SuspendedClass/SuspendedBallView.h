//
//  SuspendedBallView.h
//  KeyWindowAlertShow
//
//  Created by chenpeng on 15/11/4.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SuspendedBallLocation) {
    SuspendedBallLocation_LeftTop     = 0,
    SuspendedBallLocation_Top         = 1,
    SuspendedBallLocation_RightTop    = 2,
    SuspendedBallLocation_Right       = 3,
    SuspendedBallLocation_RightBottom = 4,
    SuspendedBallLocation_Bottom      = 5,
    SuspendedBallLocation_LeftBottom  = 6,
    SuspendedBallLocation_Left
};

@protocol SuspendedBallDelegate <NSObject>
//点击ballcell触发事件
@optional
- (void)suspendedBall:(UIView *)view didSelectBallCellAtIndex:(NSInteger)index;

@end

@interface SuspendedBallView : UIView<UIGestureRecognizerDelegate>
//UI
@property (strong, nonatomic) UIImageView *ballView;
//Data
@property (strong, nonatomic) NSArray *imagesMenu;
@property (strong, nonatomic) NSMutableArray *menuViews;
@property (assign, nonatomic) CGPoint currentCenter;
@property (assign, nonatomic) CGPoint panEndCenter;
@property (assign, nonatomic) CGPoint showMenuPoint;
@property (assign, nonatomic) NSInteger currentNo;
@property (assign, nonatomic) SuspendedBallLocation currentLocation;
@property (assign, nonatomic) BOOL    showMenu;

@property (weak, nonatomic) id <SuspendedBallDelegate> delegate;
//response
+ (void)showBallViewWithImages:(NSArray *)images andTarget:(id)delegate;

@end


