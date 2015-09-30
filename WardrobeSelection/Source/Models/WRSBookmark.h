//
//  WRSBookmark.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRSWearable;
@class WRSLoggedInUser;

@interface WRSBookmark : NSManagedObject

@property (nonatomic, retain) WRSWearable *shirt;
@property (nonatomic, retain) WRSWearable *pant;
@property (nonatomic, retain) NSNumber *timestamp;
@property (nonatomic, retain) WRSLoggedInUser *user;
@end
