//
//  UIImage+WRSHelper.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 28/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "UIImage+WRSHelper.h"
#import "UIView+Frames.h"

@implementation UIImage (WRSHelper)

-(UIImage*)thumbnailImageOfSize:(CGSize)maxSize {
    
    CGSize destinationSize = [UIView sizeThatFitsInSize:maxSize mantaingRatioOfSize:self.size];
    UIGraphicsBeginImageContext(destinationSize);
    [self drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
