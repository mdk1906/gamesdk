//
//  UIView+FrameMethods_h.m
//  GreenFruitframework
//
//  Created by shuangfei on 2018/3/5.
//  Copyright © 2018年 Hu. All rights reserved.
//

#import "OrangeUIView+FrameMethods.h"

@implementation UIView (FrameMethods)

- (CGFloat)originX{
    return self.frame.origin.x;
}

- (CGFloat)originY{
    return self.frame.origin.y;
}
- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x + horizontal, origionRect.origin.y + vertical, origionRect.size.width, origionRect.size.height);
    self.frame = newRect;
}

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x + horizontal,
                                origionRect.origin.y + vertical,
                                origionRect.size.width + widthAdded,
                                origionRect.size.height + heightAdded);
    self.frame = newRect;
}

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(horizontal, vertical, origionRect.size.width, origionRect.size.height);
    self.frame = newRect;
}

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical setWidth:(CGFloat)width setHeight:(CGFloat)height
{
    CGRect newRect = CGRectMake(horizontal, vertical, width, height);
    self.frame = newRect;
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, height);
    self.frame = newRect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, origionRect.size.height);
    self.frame = newRect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, height);
    self.frame = newRect;
}

- (void)addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded
{
    CGRect originRect = self.frame;
    CGFloat newWidth = originRect.size.width + widthAdded;
    CGFloat newHeight = originRect.size.height + heightAdded;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, newWidth, newHeight);
    self.frame = newRect;
}

- (void)addWidth:(CGFloat)widthAdded
{
    [self addWidth:widthAdded addHeight:0];
}

- (void)addHeight:(CGFloat)heightAdded
{
    [self addWidth:0 addHeight:heightAdded];
}

- (void)setCornerRadius:(CGFloat)radius
{
    [self setCornerRadius:radius borderColor:[UIColor grayColor]];
}

- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor
{
    [self.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self.layer setBorderColor:[borderColor CGColor]];
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
    self.clipsToBounds = YES;
}

- (CGRect)frameInWindow
{
    CGRect frameInWindow = [self.superview convertRect:self.frame
                                                toView:self.window];
    return frameInWindow;
}

@end
