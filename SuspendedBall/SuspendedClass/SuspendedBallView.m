//
//  SuspendedBallView.m
//  KeyWindowAlertShow
//
//  Created by chenpeng on 15/11/4.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "SuspendedBallView.h"
#import "SuspendedConfig.h"

#define ScreenHeight  [[UIScreen mainScreen]bounds].size.height
#define ScreenWidth   [[UIScreen mainScreen]bounds].size.width
#define cornerRadio    30.0f
#define placeWidth     5.0f
#define centerX        30.0f
#define centerY        30.0f
#define WeakSelf       __weak typeof(self) weakSelf = self
#define StrongSelf     __strong typeof(weakSelf) strongSelf = weakSelf
@implementation SuspendedBallView

+ (SuspendedBallView *)createView
{
    static dispatch_once_t token;
    static SuspendedBallView *ballView;
    dispatch_once(&token, ^{
        ballView = [[SuspendedBallView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [ballView configBallView];
    });
    return ballView;
}

+ (void)showBallViewWithImages:(NSArray *)images andTarget:(id)delegate;
{
    [SuspendedBallView createView].imagesMenu = images;
    [SuspendedBallView createView].delegate = delegate;
    [[UIApplication sharedApplication].keyWindow addSubview:[SuspendedBallView createView]];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:[SuspendedBallView createView]];
}

#pragma mark - private response

- (void)configBallView
{
    
    [self addSubview:self.ballView];
    [self configViewLayer:self];
    self.currentCenter = [SuspendedConfig achiveSuspendedBallCenter];
    [self calculateShowCenter:self.currentCenter];
    [self configLocation:self.currentCenter];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenuImages:)];
    tapGes.numberOfTapsRequired = 1.0f;
    tapGes.numberOfTouchesRequired = 1.0f;
    [self addGestureRecognizer:tapGes];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragBallView:)];
    [self addGestureRecognizer:panGes];
    
    
}

- (void)dragBallView:(UIPanGestureRecognizer *)panGes
{
    CGPoint translation = [panGes translationInView:[UIApplication sharedApplication].keyWindow];
    CGPoint center = self.center;
    self.center = CGPointMake(center.x+translation.x, center.y+translation.y);
    [panGes setTranslation:CGPointMake(0, 0) inView:[UIApplication sharedApplication].keyWindow];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.showMenu = NO;
        [self hiddenAllShowMenus];
    }
    else if (panGes.state == UIGestureRecognizerStateEnded)
    {
        self.panEndCenter = self.center;
        [self caculateBallCenter];
    }
}

- (void)caculateBallCenter
{
    if (self.panEndCenter.x>centerX && self.panEndCenter.x< ScreenWidth-centerX && self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY) {
        if (self.panEndCenter.y<3*centerY) {
            [self calculateBallNewCenter:CGPointMake(self.panEndCenter.x, centerY)];
        }
        else if (self.panEndCenter.y>ScreenHeight-3*centerY)
        {
            [self calculateBallNewCenter:CGPointMake(self.panEndCenter.x, ScreenHeight-centerY)];
        }
        else
        {
            if (self.panEndCenter.x<=ScreenWidth/2) {
                [self calculateBallNewCenter:CGPointMake(centerX, self.panEndCenter.y)];
            }
            else{
                [self calculateBallNewCenter: CGPointMake(ScreenWidth-centerX, self.panEndCenter.y)];
            }
        }
    }
    else
    {
        if (self.panEndCenter.x<=centerX && self.panEndCenter.y<=centerY)
        {
            [self calculateBallNewCenter: CGPointMake(centerX, centerY)];
        }
        else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y<=centerY)
        {
            [self calculateBallNewCenter: CGPointMake(ScreenWidth-centerX, centerY)];
        }
        else if (self.panEndCenter.x>=ScreenWidth-centerX && self.panEndCenter.y>=ScreenHeight-centerY)
        {
            [self calculateBallNewCenter:CGPointMake(ScreenWidth-centerX, ScreenHeight-centerY)];
        }
        else if(self.panEndCenter.x<=centerX && self.panEndCenter.y>=ScreenHeight-centerY)
        {
            [self calculateBallNewCenter:CGPointMake(centerX, ScreenHeight-centerY)];
        }
        else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y<centerY)
        {
            [self calculateBallNewCenter:CGPointMake(self.panEndCenter.x,centerY)];
        }
        else if (self.panEndCenter.x>centerX && self.panEndCenter.x<ScreenWidth-centerX && self.panEndCenter.y>ScreenHeight-centerY)
        {
            [self calculateBallNewCenter:CGPointMake(self.panEndCenter.x,ScreenHeight-centerY)];
        }
        else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x<centerX)
        {
            [self calculateBallNewCenter: CGPointMake(centerX,self.panEndCenter.y)];
        }
        else if (self.panEndCenter.y>centerY && self.panEndCenter.y<ScreenHeight-centerY && self.panEndCenter.x>ScreenWidth-centerX)
        {
            [self calculateBallNewCenter: CGPointMake(ScreenWidth-centerX,self.panEndCenter.y)];
        }
    }
}

- (void)calculateBallNewCenter:(CGPoint)point
{
    [SuspendedConfig saveSuspendedBallCenter:point];
    self.currentCenter = point;
    [self configLocation:point];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.center = CGPointMake(point.x,point.y);
    }];
}

- (void)calculateShowCenter: (CGPoint)point
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.center = CGPointMake(point.x,point.y);
    }];
}

- (void)configLocation:(CGPoint)point
{
    if (point.x <= centerX*3 && point.y <= centerY*3) {
        self.currentLocation = SuspendedBallLocation_LeftTop;
    }
    else if (point.x>centerX*3 && point.x<ScreenWidth-centerX*3 && point.y == centerY)
    {
        self.currentLocation = SuspendedBallLocation_Top;
    }
    else if (point.x >= ScreenWidth-centerX*3 && point.y <= 3*centerY)
    {
        self.currentLocation = SuspendedBallLocation_RightTop;
    }
    else if (point.x == ScreenWidth-centerX && point.y>3*centerY && point.y<ScreenHeight-centerY*3)
    {
        self.currentLocation = SuspendedBallLocation_Right;
    }
    else if (point.x >= ScreenWidth-3*centerX && point.y >= ScreenHeight-3*centerY)
    {
        self.currentLocation = SuspendedBallLocation_RightBottom;
    }
    else if (point.y == ScreenHeight-centerY && point.x > 3*centerX &&point.x<ScreenWidth-3*centerX)
    {
        self.currentLocation = SuspendedBallLocation_Bottom;
    }
    else if (point.x <= 3*centerX && point.y >= ScreenHeight-3*centerY)
    {
        self.currentLocation = SuspendedBallLocation_LeftBottom;
    }
    else if (point.x == centerX && point.y > 3*centerY && point.y<ScreenHeight-3*centerY)
    {
        self.currentLocation = SuspendedBallLocation_Left;
    }
}

- (void)configViewLayer:(UIView *)view
{
    view.layer.cornerRadius = cornerRadio;
    view.layer.shadowColor = [UIColor grayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(5, 8);
    view.layer.shadowRadius = 5.0f;
    view.layer.shadowOpacity = 0.8;
}

- (void)showMenuImages:(UITapGestureRecognizer *)tapGes
{
    if (self.imagesMenu.count == 0) {
        
    }
    else
    {
        if (self.showMenu) {
            [self shutDownMenu];
        }
        else{
            [self openTheMenu];
        }
    }
}

- (void)openTheMenu
{
    [self configMenuView];
    if (self.currentLocation == SuspendedBallLocation_Left) {
        [self calculateShowCenter:CGPointMake(self.currentCenter.x+centerX*2+placeWidth, self.currentCenter.y)];
        
        [self configShowMenuViewcenter:CGPointMake(self.currentCenter.x+centerX*2+placeWidth, self.currentCenter.y)];
        
    }
    else if (self.currentLocation == SuspendedBallLocation_LeftTop)
    {
        [self calculateShowCenter:CGPointMake(3*centerX+placeWidth, 3*centerY+placeWidth)];
        [self configShowMenuViewcenter:CGPointMake(3*centerX+placeWidth, 3*centerY+placeWidth)];
    }
    else if (self.currentLocation == SuspendedBallLocation_Top)
    {
        [self calculateShowCenter:CGPointMake(self.currentCenter.x, self.currentCenter.y+2*centerY+placeWidth)];
        [self configShowMenuViewcenter:CGPointMake(self.currentCenter.x, self.currentCenter.y+2*centerY+placeWidth)];
    }
    else if (self.currentLocation == SuspendedBallLocation_RightTop)
    {
        [self calculateShowCenter:CGPointMake(3*centerX+placeWidth, 3*centerY+placeWidth)];
        [self configShowMenuViewcenter:CGPointMake(3*centerX+placeWidth, 3*centerY+placeWidth)];
    }
    else if (self.currentLocation == SuspendedBallLocation_Right)
    {
        [self calculateShowCenter:CGPointMake(ScreenWidth-3*centerX-placeWidth,self.currentCenter.y)];
        [self configShowMenuViewcenter:CGPointMake(ScreenWidth-3*centerX-placeWidth,self.currentCenter.y)];
    }
    else if (self.currentLocation == SuspendedBallLocation_RightBottom)
    {
        [self calculateShowCenter:CGPointMake(ScreenWidth-3*centerX-placeWidth,ScreenHeight-3*centerY-placeWidth)];
        [self configShowMenuViewcenter:CGPointMake(ScreenWidth-3*centerX-placeWidth,ScreenHeight-3*centerY-placeWidth)];
    }
    else if (self.currentLocation == SuspendedBallLocation_Bottom)
    {
        [self calculateShowCenter:CGPointMake(self.currentCenter.x,ScreenHeight-3*centerY-placeWidth)];
        [self configShowMenuViewcenter:CGPointMake(self.currentCenter.x,ScreenHeight-3*centerY-placeWidth)];
    }
    else if (self.currentLocation == SuspendedBallLocation_LeftBottom)
    {
        [self calculateShowCenter:CGPointMake(3*centerX+placeWidth,ScreenHeight-3*centerY-placeWidth)];
        [self configShowMenuViewcenter:CGPointMake(3*centerX+placeWidth,ScreenHeight-3*centerY-placeWidth)];
    }

    self.showMenu = YES;

}

- (void)configShowMenuViewcenter:(CGPoint)point{
    self.showMenuPoint = point;
    for (int i =0; i<self.imagesMenu.count; i++) {
        UIImageView *imageView = [self.menuViews objectAtIndex:i];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showMenu:Hidden:) object:imageView];
        [self performSelector:@selector(showMenu:Hidden:) withObject:imageView afterDelay:0.3+i/100];
        
        [[UIApplication sharedApplication].keyWindow addSubview:imageView];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:imageView];
        if (i==0) {
            imageView.center = CGPointMake(point.x-2*centerX-placeWidth, point.y);
        }
        else if (i==1)
        {
            imageView.center = CGPointMake(point.x, point.y-2*centerY-placeWidth);
        }
        else if (i==2)
        {
            imageView.center = CGPointMake(point.x+2*centerX+placeWidth, point.y);
        }
        else
        {
            imageView.center = CGPointMake(point.x, point.y+2*centerY+placeWidth);
        }
    }

}

- (void)showMenu:(UIView *)view Hidden:(BOOL)hidden
{
    view.hidden = NO;
}

- (void)shutDownMenu
{
    [self hiddenAllShowMenus];
    [self calculateBallNewCenter:self.currentCenter];
    self.showMenu = NO;
    
}

- (void)hiddenAllShowMenus
{
     __weak typeof(self) weakSelf = self;
    [self.menuViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = (UIImageView *)obj;
        [UIView animateWithDuration:0.1 delay:idx/100 options:UIViewAnimationOptionCurveEaseOut animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            imageView.center = strongSelf.showMenuPoint;
        } completion:^(BOOL finished) {
            imageView.hidden = YES;
        }];
    }];
}

- (void)configMenuView
{
    if (self.menuViews.count>0) {
        return;
    }
    for (int i = 0; i<self.imagesMenu.count; i++) {
        UIImageView *menuView = [[UIImageView alloc]initWithFrame:self.frame];
        [self configViewLayer:menuView];
        menuView.userInteractionEnabled = YES;
        menuView.image = [self.imagesMenu objectAtIndex:i];
        menuView.hidden = YES;
        menuView.tag = i;
        
        UITapGestureRecognizer *MenuGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MenuAction:)];
        MenuGes.numberOfTapsRequired = 1.0f;
        MenuGes.numberOfTouchesRequired = 1.0f;
        [menuView addGestureRecognizer:MenuGes];
        
        [self.menuViews addObject:menuView];
    }
}

- (void)MenuAction:(UITapGestureRecognizer *)tapGes
{
    if (_delegate && [_delegate respondsToSelector:@selector(suspendedBall:didSelectBallCellAtIndex:)]) {
        [_delegate suspendedBall:tapGes.view didSelectBallCellAtIndex:tapGes.view.tag];
    }
}

#pragma mark - getter

- (UIImageView *)ballView
{
    if (!_ballView) {
        _ballView = [[UIImageView alloc]initWithFrame:self.frame];
        [_ballView setImage:[UIImage imageNamed:@"icon_noneThing"]];
    }
    return _ballView;
}

- (NSMutableArray *)menuViews{
    if (!_menuViews) {
        _menuViews = [NSMutableArray array];
    }
    return _menuViews;
}

@end
