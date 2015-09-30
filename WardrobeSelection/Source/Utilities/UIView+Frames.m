//
//  UIView+Frames.m
//
//  Created by Abhinav Singh on 26/12/13.
//  Copyright (c) 2013 Vercingetorix Technologies Pvt. Ltd. All rights reserved.
//

#import "UIView+Frames.h"

@implementation UIView (Frames)

- (CGFloat) maxX {
	return (self.frame.size.width+self.frame.origin.x);
}

- (CGFloat) maxY {
	return (self.frame.size.height+self.frame.origin.y);
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setSize:(CGSize)size {

	CGRect prev = self.frame;
	prev.size.height = size.height;
	prev.size.width = size.width;
	self.frame = prev;
}

- (CGFloat)originX {
	return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)xAxics {
	CGRect prev = self.frame;
	prev.origin.x = xAxics;
	self.frame = prev;
}

- (CGFloat)originY {
	
	return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)yAxics {
	CGRect prev = self.frame;
	prev.origin.y = yAxics;
	self.frame = prev;
}

- (CGFloat)height {

	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {

	CGRect prev = self.frame;
	prev.size.height = height;
	self.frame = prev;
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
	CGRect prev = self.frame;
	prev.size.width = width;
	self.frame = prev;
}

- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerX {
	return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}
- (CGFloat)centerY {
	return self.center.y;
}

- (CGPoint)centerPoint {

	return CGPointMake(self.width/2, self.height/2);
}

+(CGSize)sizeThatFitsInSize:(CGSize)maxAllowed mantaingRatioOfSize:(CGSize)refrenceSize {
    
    CGFloat maxWidthAllowed = maxAllowed.width;
    CGFloat maxHeightAllowed = maxAllowed.height;
    
    CGFloat width = refrenceSize.width;
    CGFloat height = refrenceSize.height;
    CGFloat whRatio = (width/height);
    
    if (whRatio >= 1.0) {
        //Width is greater than OR equal to height.
        
        if (width > maxWidthAllowed) {
            width = maxWidthAllowed;
        }
        
        height = (width/whRatio);
        if (height > maxHeightAllowed) {
            
            height = maxHeightAllowed;
            width = (whRatio*height);
        }
    }else {
        
        //Width is smaller than height.
        if (height > maxHeightAllowed) {
            height = maxHeightAllowed;
        }
        
        width = (whRatio*height);
        if (width > maxWidthAllowed) {
            
            width = maxWidthAllowed;
            height = (width/whRatio);
        }
    }
    
    return CGSizeMake(width, height);
}

@end
