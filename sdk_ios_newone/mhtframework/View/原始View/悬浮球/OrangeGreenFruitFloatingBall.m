//
//  OrangeGreenFruitFloatingBall.m
//  OrangeGreenFruitFloatingBall
//
//  Created by GreenFruittletoe on 2017/4/22.
//  Copyright © 2017年 GreenFruittletoe. All rights reserved.
//

#import "OrangeGreenFruitFloatingBall.h"
#include <objc/runtime.h>
#import "OrangeUIView+FrameMethods.h"
#import "OrangeGreenFruitConfig.h"

#pragma mark - GreenFruitFloatingBallWindow

@interface GreenFruitFloatingBallWindow : UIWindow
@end

@implementation GreenFruitFloatingBallWindow

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    __block OrangeGreenFruitFloatingBall *floatingBall = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[OrangeGreenFruitFloatingBall class]]) {
            floatingBall = (OrangeGreenFruitFloatingBall *)obj;
            *stop = YES;
        }
    }];
    
    if (CGRectContainsPoint(floatingBall.bounds,
            [floatingBall convertPoint:point fromView:self])) {
        return [super pointInside:point withEvent:event];
    }
    
    return NO;
}
@end

#pragma mark - GreenFruitFloatingBallManager

@interface GreenFruitFloatingBallManager : NSObject
@property (nonatomic, assign) BOOL canRuntime;
@property (nonatomic,   weak) UIView *superView;
@end

@implementation GreenFruitFloatingBallManager

+ (instancetype)share_CustomNativeByte_Manager {
    static GreenFruitFloatingBallManager *ballMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ballMgr = [[GreenFruitFloatingBallManager alloc] init];
        
    });
    
    return ballMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canRuntime = NO;
        
    }
    return self;
}


@end

#pragma mark - UIView (GreenFruitAddSubview)

@interface UIView (GreenFruitAddSubview)

@end

@implementation UIView (GreenFruitAddSubview)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(addSubview:)), class_getInstanceMethod(self, @selector(GreenFruit_addSubview:)));
    });
}

- (void)GreenFruit_addSubview:(UIView *)subview {
    [self GreenFruit_addSubview:subview];
    
    if ([GreenFruitFloatingBallManager share_CustomNativeByte_Manager].canRuntime) {
        if ([[GreenFruitFloatingBallManager share_CustomNativeByte_Manager].superView isEqual:self]) {
            [self.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[OrangeGreenFruitFloatingBall class]]) {
                    [self insertSubview:subview belowSubview:(OrangeGreenFruitFloatingBall *)obj];
                }
            }];
        }
    }
}

@end

#pragma mark - OrangeGreenFruitFloatingBall

@interface OrangeGreenFruitFloatingBall()

@property (nonatomic, assign) CGPoint centerOffset;
@property (nonatomic,   copy) GreenFruitEdgeRetractConfig(^edgeRetractConfigHander)();
@property (nonatomic, assign) NSTimeInterval autoEdgeOffsetDuration;
@property (nonatomic, strong) UIView *parentView;
// content
@property (nonatomic, strong) UIImageView *ballImageView;
@property (nonatomic, strong) UILabel *ballLabel;
@property (nonatomic, strong) UIView *ballCustomView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;//滑动的手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;//点击的手势
@property (nonatomic, assign) UIEdgeInsets effectiveEdgeInsets;
//新增
@property (nonatomic, retain) UIView * cancleView;
@property (nonatomic, retain) UILabel * infolabel;
@property (nonatomic, retain) UILabel * mesLabel;
@property (nonatomic, assign) BOOL weatherShow;//旋转时是否出现

@end

static const NSInteger minUpDownLimits = 60 * 1.5f;   // GreenFruitFloatingBallEdgePolicyAllEdge 下，悬浮球到达一个界限开始自动靠近上下边缘

#ifndef __OPTIMIZE__
#define GreenFruitLog(...) NSLog(__VA_ARGS__)
#else
#define GreenFruitLog(...) {}
#endif

@implementation OrangeGreenFruitFloatingBall

#pragma mark - Life Cycle

- (void)dealloc {
    GreenFruitLog(@"OrangeGreenFruitFloatingBall dealloc");
    [GreenFruitFloatingBallManager share_CustomNativeByte_Manager].canRuntime = NO;
    [GreenFruitFloatingBallManager share_CustomNativeByte_Manager].superView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame inSpecifiedView:nil effectiveEdgeInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithFrame:(CGRect)frame inSpecifiedView:(UIView *)specifiedView {
    return [self initWithFrame:frame inSpecifiedView:specifiedView effectiveEdgeInsets:UIEdgeInsetsZero];
}

- (instancetype)initWithFrame:(CGRect)frame inSpecifiedView:(UIView *)specifiedView effectiveEdgeInsets:(UIEdgeInsets)effectiveEdgeInsets {
    self = [super initWithFrame:frame];
    if (self) {//监听设备旋转
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:@"FloatingBallAutoEdgeOffSet" object:nil];
        self.backgroundColor = [UIColor clearColor];
        _autoEdgeOffSet = NO;
        _autoCloseEdge = NO;
        _autoEdgeRetract = NO;
        _edgePolicy = GreenFruitFloatingBallEdgePolicyAllEdge;
        _effectiveEdgeInsets = effectiveEdgeInsets;
        self.weatherShow = NO;
        self.weatherClose = YES;

        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.panGesture];
        [self configSpecifiedView:specifiedView];
    }
    return self;
}

- (void)configSpecifiedView:(UIView *)specifiedView {
    if (specifiedView) {
        _parentView = specifiedView;
    }
    else {
        UIWindow *window = [[GreenFruitFloatingBallWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = CGFLOAT_MAX; //UIWindowLevelStatusBar - 1;
        window.rootViewController = [UIViewController new];
        window.rootViewController.view.backgroundColor = [UIColor clearColor];
        window.rootViewController.view.userInteractionEnabled = NO;
        [window makeKeyAndVisible];
        
        _parentView = window;
    }
    
    _parentView.hidden = YES;
    _centerOffset = CGPointMake(_parentView.bounds.size.width * 0.6, _parentView.bounds.size.height * 0.6);
    
    // setup ball manager
    [GreenFruitFloatingBallManager share_CustomNativeByte_Manager].canRuntime = YES;
    [GreenFruitFloatingBallManager share_CustomNativeByte_Manager].superView = specifiedView;
}



#pragma mark - Private Methods

// 靠边
- (void)autoCloseEdge {
    
    [UIView animateWithDuration:0.1f animations:^{
        // center
        self.center = [self calculatePoisitionWithEndOffset:CGPointZero];
        
    } completion:^(BOOL finished) {
                
//        // 靠边之后自动缩进边缘处
//        if (self.isAutoEdgeRetract) {//Get方法，是否建立了自动靠边
//            [self performSelector:@selector(autoEdgeOffset) withObject:nil afterDelay:self.autoEdgeOffsetDuration];
//        }
        // 靠边之后自动缩进边缘处
        if (self.weatherClose == YES) {//Get方法，是否建立了自动靠边
            [self performSelector:@selector(autoEdgeOffset) withObject:nil afterDelay:self.autoEdgeOffsetDuration];
        }
    }];
}

- (void)autoEdgeOffset {
    if (self.weatherClose == YES) {
        GreenFruitEdgeRetractConfig config = self.edgeRetractConfigHander ? self.edgeRetractConfigHander() : GreenFruitEdgeOffsetConfigMake(CGPointMake(self.bounds.size.width * 0.3, self.bounds.size.height * 0.3), 0.8);
        [UIView animateWithDuration:0.5f animations:^{
            
            self.autoEdgeOffSet = YES;
            self.center = [self calculatePoisitionWithEndOffset:config.edgeRetractOffset];
            self.alpha = config.edgeRetractAlpha;
            self.isTatalShow = NO;

        }];
    }
    else{
//        NSLog(@"不走靠边动画了");
    }
}

- (void)floatingBallShowAll{
    [self performSelector:@selector(autoEdgeOffSetShow) withObject:nil];
}

- (void)autoEdgeOffSetShow{
    self.autoEdgeOffSet = NO;
    [UIView animateWithDuration:0.5f animations:^{
        // center
        self.center = [self calculatePoisitionWithEndOffset:CGPointZero];//center;
        self.isTatalShow = YES;
        
    } completion:^(BOOL finished) {
        // 靠边之后自动缩进边缘处
//        if (self.isAutoEdgeRetract) {
//            [self performSelector:@selector(autoEdgeOffset) withObject:nil afterDelay:self.autoEdgeOffsetDuration];
//        }
        if (self.weatherClose == YES) {
            [self performSelector:@selector(autoEdgeOffset) withObject:nil afterDelay:self.autoEdgeOffsetDuration];
        }else{
//            NSLog(@"不走这个靠边方法");
        }
    }];
}

- (CGPoint)calculatePoisitionWithEndOffset:(CGPoint)offset {
    CGFloat ballHalfW   = self.bounds.size.width * 0.5;
    CGFloat ballHalfH   = self.bounds.size.height * 0.5;
    CGFloat parentViewW = self.parentView.bounds.size.width;
    CGFloat parentViewH = self.parentView.bounds.size.height;
    CGPoint center = self.center;
    
    if (GreenFruitFloatingBallEdgePolicyLeftRight == self.edgePolicy) {

        center.x = (center.x < self.parentView.bounds.size.width * 0.5) ? (ballHalfW - offset.x + self.effectiveEdgeInsets.left) : (parentViewW + offset.x - ballHalfW + self.effectiveEdgeInsets.right);
        if(center.y > parentViewH){
            center.y = parentViewH/2;
        }
    }
    else if (GreenFruitFloatingBallEdgePolicyUpDown == self.edgePolicy) {
        NSLog(@"上下");
        center.y = (center.y < self.parentView.bounds.size.height * 0.5) ? (ballHalfH - offset.y + self.effectiveEdgeInsets.top) : (parentViewH + offset.y - ballHalfH + self.effectiveEdgeInsets.bottom);
    }
    else if (GreenFruitFloatingBallEdgePolicyAllEdge == self.edgePolicy) {
        if (center.y < minUpDownLimits) {
//            NSLog(@"情况1");
            center.y = ballHalfH - offset.y + self.effectiveEdgeInsets.top;
        }
        else if (center.y > parentViewH - minUpDownLimits) {
//            NSLog(@"情况2");
            center.y = parentViewH + offset.y - ballHalfH + self.effectiveEdgeInsets.bottom;
        }
        else {
//            NSLog(@"情况3");
            center.x = (center.x < self.parentView.bounds.size.width  * 0.5) ? (ballHalfW - offset.x + self.effectiveEdgeInsets.left) : (parentViewW + offset.x - ballHalfW + self.effectiveEdgeInsets.right);
        }
    }
    return center;
}

#pragma mark --- 设备旋转时方法
- (void)statusBarOrientationChange:(NSNotification *)notification
{
    //设备旋转时，隐藏悬浮球
    [self autoCloseEdge];
    
    [self.cancleView removeFromSuperview];
    self.cancleView = nil;
    
    if (self.weatherShow == YES) {
        [self show];
        self.weatherShow = NO;
    }else{
        NSLog(@"此时悬浮球不出现");
    }
}

#pragma mark - Public Methods

- (void)show {
    self.parentView.hidden = NO;
    [self.parentView addSubview:self];
}

- (void)hide {
    self.parentView.hidden = NO;
    [self removeFromSuperview];
}

- (void)visible {
    [self show];
}

- (void)disVisible {
    [self hide];
}

- (void)autoEdgeRetractDuration:(NSTimeInterval)duration edgeRetractConfigHander:(GreenFruitEdgeRetractConfig (^)())edgeRetractConfigHander {
//    if (self.isAutoCloseEdge == YES) {
//        // 只有自动靠近边缘的时候才生效
//        self.edgeRetractConfigHander = edgeRetractConfigHander;
//        self.autoEdgeOffsetDuration = duration;
//        self.autoEdgeRetract = YES;
//    }

    if (self.autoCloseEdge == YES) {
        
        // 只有自动靠近边缘的时候才生效
        self.edgeRetractConfigHander = edgeRetractConfigHander;
        self.autoEdgeOffsetDuration = duration;
        self.autoEdgeRetract = YES;
        self.weatherClose = YES;
    }
}

- (void)setContent:(id)content contentType:(GreenFruitFloatingBallContentType)contentType {
    BOOL notUnknowType = (GreenFruitFloatingBallContentTypeCustomView == contentType) || (GreenFruitFloatingBallContentTypeImage == contentType) || (GreenFruitFloatingBallContentTypeText == contentType);
    NSAssert(notUnknowType, @"can't set ball content with an unknow content type");
    
    [self.ballCustomView removeFromSuperview];
    if (GreenFruitFloatingBallContentTypeImage == contentType) {
        NSAssert([content isKindOfClass:[UIImage class]], @"can't set ball content with a not image content for image type");
        [self.ballLabel setHidden:YES];
        [self.ballCustomView setHidden:YES];
        [self.ballImageView setHidden:NO];
        [self.ballImageView setImage:(UIImage *)content];
    }
    else if (GreenFruitFloatingBallContentTypeText == contentType) {
        NSAssert([content isKindOfClass:[NSString class]], @"can't set ball content with a not nsstring content for text type");
        [self.ballLabel setHidden:NO];
        [self.ballCustomView setHidden:YES];
        [self.ballImageView setHidden:YES];
        [self.ballLabel setText:(NSString *)content];
    }
    else if (GreenFruitFloatingBallContentTypeCustomView == contentType) {
        NSAssert([content isKindOfClass:[UIView class]], @"can't set ball content with a not uiview content for custom view type");
        [self.ballLabel setHidden:YES];
        [self.ballCustomView setHidden:NO];
        [self.ballImageView setHidden:YES];
        
        self.ballCustomView = (UIView *)content;
        
        CGRect frame = self.ballCustomView.frame;
        frame.origin.x = (self.bounds.size.width - self.ballCustomView.bounds.size.width) * 0.5;
        frame.origin.y = (self.bounds.size.height - self.ballCustomView.bounds.size.height) * 0.5;
        self.ballCustomView.frame = frame;
        
        self.ballCustomView.userInteractionEnabled = NO;
        [self addSubview:self.ballCustomView];
    }
}

#pragma mark - GestureRecognizer
-(void)canclePanGestureMethod{

//    NSLog(@"取消可以拖动的手势");
    [self removeGestureRecognizer:self.panGesture];
    
}

-(void)openPanGestureMethod{
     self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self addGestureRecognizer:self.panGesture];
    
}

// 手势处理
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    if (UIGestureRecognizerStateBegan == panGesture.state) {
        [self setAlpha:1.0f];
        // cancel
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoEdgeOffset) object:nil];
        
        //开始滑动后，在页面右下方出现红色区域，可以滑动到里面时隐藏悬浮球
//        NSLog(@"开始滑动悬浮球");
        
        if (self.cancleView == nil) {
            self.cancleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            self.cancleView.backgroundColor = [UIColor lightGrayColor];
            [self.superview addSubview:self.cancleView];
            
            [UIView animateWithDuration:1.0f animations:^{
                self.cancleView.alpha = 0.6;
                self.cancleView.frame = CGRectMake(0, 0, kScreenWidth, 64);
//                self.cancleView.layer.cornerRadius = 100;
                
            } completion:^(BOOL finished) {
                self.infolabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, kScreenWidth-60, 34)];
                self.infolabel.text = @"拖拽至此区域隐藏\n屏幕旋转可再次显示悬浮球";
                self.infolabel.numberOfLines = 0;
                self.infolabel.textAlignment = NSTextAlignmentCenter;
                self.infolabel.font = [UIFont systemFontOfSize:14.0f];
                self.infolabel.backgroundColor = [UIColor clearColor];
                self.infolabel.textColor = [UIColor whiteColor];
                [self.cancleView addSubview:self.infolabel];
                
//                self.mesLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, self.infolabel.frame.origin.y + 25, kScreenWidth-60, 15)];
//                self.mesLabel.text = @"屏幕旋转可再次显示悬浮球";
//                self.mesLabel.textAlignment = NSTextAlignmentCenter;
//                self.mesLabel.font = [UIFont systemFontOfSize:13.0f];
//                self.mesLabel.backgroundColor = [UIColor clearColor];
//                self.mesLabel.textColor = [UIColor whiteColor];
//                [self.cancleView addSubview:self.mesLabel];
            }];
            
        }

    }
    else if (UIGestureRecognizerStateChanged == panGesture.state) {
        
        // 全局并发队列的获取方法
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        CGPoint translation = [panGesture translationInView:self];
        CGPoint center = self.center;
        center.x += translation.x;
        center.y += translation.y;
        self.center = center;
        
        CGFloat   leftMinX = 0.0f + self.effectiveEdgeInsets.left;
        CGFloat    topMinY = 0.0f + self.effectiveEdgeInsets.top;
        CGFloat  rightMaxX = self.parentView.bounds.size.width - self.bounds.size.width + self.effectiveEdgeInsets.right;
        CGFloat bottomMaxY = self.parentView.bounds.size.height - self.bounds.size.height + self.effectiveEdgeInsets.bottom;
        
        CGRect frame = self.frame;
        frame.origin.x = frame.origin.x > rightMaxX ? rightMaxX : frame.origin.x;
        frame.origin.x = frame.origin.x < leftMinX ? leftMinX : frame.origin.x;
        frame.origin.y = frame.origin.y > bottomMaxY ? bottomMaxY : frame.origin.y;
        frame.origin.y = frame.origin.y < topMinY ? topMinY : frame.origin.y;
        self.frame = frame;
        
        // zero
        [panGesture setTranslation:CGPointZero inView:self];
        
        
        //滑动过程中的动态
        
        if (self.center.y<120) {
            if (self.cancleView != nil) {
                
                // 同步执行任务创建方法
                dispatch_sync(queue, ^{
                    // 这里放同步执行任务代码
                    [UIView animateWithDuration:0.5f animations:^{
                        self.cancleView.frame = CGRectMake(0,0, kScreenWidth, 70);
//                        self.cancleView.layer.cornerRadius = 120;
                        self.cancleView.backgroundColor = [UIColor lightGrayColor];
                        
                    }];
                });
                
                // 异步执行任务创建方法
                dispatch_async(queue, ^{
                    // 这里放异步执行任务代码
                });
                
            }
        }else{
            dispatch_sync(queue, ^{
                [UIView animateWithDuration:0.5f animations:^{
                    [UIView animateWithDuration:0.5f animations:^{
                        self.cancleView.frame = CGRectMake(0, 0, kScreenWidth, 64);
//                        self.cancleView.layer.cornerRadius = 100;
                        self.cancleView.backgroundColor = [UIColor lightGrayColor];
                        self.cancleView.alpha = 0.6;

                    }];
                }];
            });
        }
    }
    else if (UIGestureRecognizerStateEnded == panGesture.state) {
        if (self.isAutoCloseEdge) {
            self.autoEdgeOffSet = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 0.2s 之后靠边
                [self autoCloseEdge];
            });
        }
        
        if (self.center.y<64) {
            if (self.cancleView != nil) {
                
                [self.cancleView removeFromSuperview];
                self.cancleView = nil;
                [self hide];
                
                self.weatherShow = YES;
            }
           
        }
        else{
           
            [UIView animateWithDuration:0.7 animations:^{
                self.infolabel.alpha = 0;
                self.mesLabel.alpha = 0;
                self.cancleView.frame = CGRectMake(0, 0, 0, 0);

            } completion:^(BOOL finished) {
                [self.cancleView removeFromSuperview];
                self.cancleView = nil;
            }];
        }
        
    }
}

- (void)tapGestureRecognizer:(UIPanGestureRecognizer *)tapGesture {
    __weak __typeof(self) weakSelf = self;
    if (self.clickHandler) {
        self.clickHandler(weakSelf);
    }
    
    if ([_delegate respondsToSelector:@selector(didClickFloatingBall:)]) {
        [_delegate didClickFloatingBall:self];
    }
}

#pragma mark - Setter / Getter

- (void)setAutoCloseEdge:(BOOL)autoCloseEdge {
    _autoCloseEdge = autoCloseEdge;
    
    if (autoCloseEdge) {
        [self autoCloseEdge];
    }
}

- (void)setTextTypeTextColor:(UIColor *)textTypeTextColor {
    _textTypeTextColor = textTypeTextColor;
    
    [self.ballLabel setTextColor:textTypeTextColor];
}

- (UIImageView *)ballImageView {
    if (!_ballImageView) {
        _ballImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_ballImageView];
    }
    return _ballImageView;
}

- (UILabel *)ballLabel {
    if (!_ballLabel) {
        _ballLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _ballLabel.textAlignment = NSTextAlignmentCenter;
        _ballLabel.numberOfLines = 1.0f;
        _ballLabel.minimumScaleFactor = 0.0f;
        _ballLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_ballLabel];
    }
    return _ballLabel;
}
@end
