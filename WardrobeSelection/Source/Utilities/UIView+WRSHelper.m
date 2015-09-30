//
//  UIView+WRSHelper.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "UIView+WRSHelper.h"

@implementation UIView (WRSHelper)

- (UIImage*)snapShotImage {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

@end
