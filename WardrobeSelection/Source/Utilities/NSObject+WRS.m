//
//  NSObject+WRS.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "NSObject+WRS.h"
#import "WRSRootViewController.h"
#import "WRSDatabaseManager.h"

@implementation NSObject (WRS)

-(WRSRootViewController*)rootViewController {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    WRSRootViewController *root = (WRSRootViewController*)window.rootViewController;
    return root;
}

-(WRSDatabaseManager*)database {
    return self.rootViewController.dbManager;
}

@end
