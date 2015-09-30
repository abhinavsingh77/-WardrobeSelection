//
//  WRSWearable.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WRSLoggedInUser;

typedef NS_ENUM(NSInteger, WearableType) {
    
    WearableTypeFormalPant = 0,
    WearableTypeCasualPant,
    WearableTypeJeansPant,
    
    WearableTypeFormalShirt,
    WearableTypeCasualShirt,
    WearableTypeTShirt,
    
    WearableTypePantStart = WearableTypeFormalPant,
    WearableTypePantEnd = WearableTypeJeansPant,
    
    WearableTypeShirtStart = WearableTypeFormalShirt,
    WearableTypeShirtEnd = WearableTypeTShirt,
};

@interface WRSWearable : NSManagedObject

@property (nonatomic, retain) NSString * thumbnailImageUrl;
@property (nonatomic, retain) NSString * relativeImageURL;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * wearableID;
@property (nonatomic, retain) NSString * thumbnailSize;
@property (nonatomic, retain) WRSLoggedInUser *user;

+(BOOL)isShirtType:(WearableType)type;
+(BOOL)isPantType:(WearableType)type;

+(NSArray*)allPantTypes;
+(NSArray*)allShirtTypes;
+(NSString*)displayNameForWearableType:(WearableType)type;

@end
