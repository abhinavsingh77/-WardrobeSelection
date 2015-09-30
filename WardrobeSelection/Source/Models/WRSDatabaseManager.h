//
//  WRSDatabaseManager.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSLoggedInUser.h"
#import "WRSUtility.h"
#import "WRSWearable.h"
#import "WRSBookmark.h"

FOUNDATION_EXPORT NSString *const NotifyPriortiesChanged;
FOUNDATION_EXPORT NSString *const NotifyWearableChanged;
FOUNDATION_EXPORT NSString *const NotifyBookmarkChanged;

@import CoreData;
@import UIKit;

@interface WRSDatabaseManager : NSObject {}

@property(readonly, strong) WRSLoggedInUser *loggedInUser;
@property (readonly, strong, nonatomic) NSManagedObjectContext *objectContext;

@property(readonly, strong) NSArray *allPantTypes;
@property(readonly, strong) NSArray *allShirtTypes;

-(void)saveDataBase;
-(NSString*)imagePathForName:(NSString*)name;

-(NSManagedObject*)insertNewObjectOfClass:(NSString*)className;
-(void)insertNewUserWithID:(NSString*)uID andName:(NSString*)name;

-(void)addNewWearableOfType:(NSInteger)type andImage:(UIImage*)image completion:(CompletionBlock)block;
-(void)addBookmarkForPant:(WRSWearable*)pant andShirt:(WRSWearable*)shirt completion:(CompletionBlock)block;

-(void)removeWearableObject:(WRSWearable*)wearable;
-(void)removeBookmark:(WRSBookmark*)bookmark;
-(void)removeBookmarkForPant:(WRSWearable*)pant andShirt:(WRSWearable*)shirt completion:(CompletionBlock)block;

-(WRSBookmark*)bookMarkForPant:(WRSWearable*)pant andShirt:(WRSWearable*)shirt;


-(void)savePriorties:(NSArray*)array forType:(WearableType)type;
-(NSArray*)priortiesForType:(WearableType)type;

-(NSArray*)allObjectsOfClass:(NSString*)className withPredicate:(NSPredicate*)predicate;


-(void)deleteUserAndRelatedData;

@end
