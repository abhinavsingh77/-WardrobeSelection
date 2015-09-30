//
//  UIView+Frames.h
//
//  Created by Abhinav Singh on 26/12/13.
//  Copyright (c) 2013 Vercingetorix Technologies Pvt. Ltd. All rights reserved.
//

@import UIKit;

@interface UIView (Frames)

- (CGFloat) maxX;
- (CGFloat) maxY;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGFloat)originX;
- (void)setOriginX:(CGFloat)xAxics;

- (CGFloat)originY;
- (void)setOriginY:(CGFloat)yAxics;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGPoint)centerPoint;

- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerX;

- (void)setCenterY:(CGFloat)centerY;
- (CGFloat)centerY;

+(CGSize)sizeThatFitsInSize:(CGSize)maxAllowed mantaingRatioOfSize:(CGSize)refrenceSize;

@end
