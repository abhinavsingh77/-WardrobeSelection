//
//  UINavigationController+Helper.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "UINavigationController+Helper.h"
#import "UIFont+WRS.h"
#import "UIColor+WRS.h"

@implementation UINavigationController (Helper)

- (void)applyDefaultStyle {
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                 NSFontAttributeName:[UIFont wrsMediumFontOfSize:17]}];
    
    [self.navigationBar setBackgroundColor:[UIColor primaryColor]];
    [self.navigationBar setBarTintColor:[UIColor primaryColor]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
}

@end
