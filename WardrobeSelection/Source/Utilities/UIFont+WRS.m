//
//  UIFont+WRS.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "UIFont+WRS.h"

@implementation UIFont (WRS)

+(UIFont*)wrsMediumFontOfSize:(CGFloat)size {
    
    return [UIFont systemFontOfSize:size];
}

+(UIFont*)wrsRegularFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}

+(UIFont*)wrsBoldFontOfSize:(CGFloat)size{
    return [UIFont boldSystemFontOfSize:size];
}

@end
