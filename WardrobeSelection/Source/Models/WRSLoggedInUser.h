//
//  WRSLoggedInUser.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WRSLoggedInUser : NSManagedObject

@property (nonatomic, retain) NSString * fbID;
@property (nonatomic, retain) NSString * name;

@end
