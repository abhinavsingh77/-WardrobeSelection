//
//  NSObject+WRS.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WRSRootViewController;
@class WRSDatabaseManager;

@interface NSObject (WRS)

-(WRSRootViewController*)rootViewController;
-(WRSDatabaseManager*)database;

@end
