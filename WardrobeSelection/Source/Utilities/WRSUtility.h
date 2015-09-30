//
//  WRSUtility.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+Helper.h"
#import "UIColor+WRS.h"
#import "UIFont+WRS.h"
#import "UIView+Frames.h"
#import "UINavigationController+Helper.h"
#import "NSObject+WRS.h"
#import "NSObject+WRSError.h"
#import "UIView+WRSHelper.h"
#import "UIImage+WRSHelper.h"

typedef void (^ SuccessBlock)(BOOL success);
typedef void (^ CompletionBlock)(id data, NSError *error);