//
//  WRSDatabaseManager.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSDatabaseManager.h"
#import "WRSWearable.h"
#import "WRSBookmark.h"

NSString *const NotifyPriortiesChanged = @"NotifyPriortiesChanged";
NSString *const NotifyWearableChanged = @"NotifyWearableChanged";
NSString *const NotifyBookmarkChanged = @"NotifyBookmarkChanged";

@interface WRSDatabaseManager () {
    
    NSMutableDictionary *priortiesDictionary;
    NSString *imageRelativeDirectory;
}

@property (strong, nonatomic) NSManagedObjectContext *mainContext;

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSURL *documentDirectory;
@property (strong, nonatomic) NSURL *imagesDirectory;

@end

@implementation WRSDatabaseManager
@synthesize objectContext = _objectContext;

#pragma mark Testing

- (void)logCountOfObjectsOfClass:(Class)cls {
    
    NSString *name = NSStringFromClass(cls);
    NSLog(@"%@:%@",name, @([self allObjectsOfClass:name].count));
}

- (void)logAllKindOfCoreDataObjectsCount {
    
    [self logCountOfObjectsOfClass:[WRSWearable class]];
    [self logCountOfObjectsOfClass:[WRSBookmark class]];
    [self logCountOfObjectsOfClass:[WRSLoggedInUser class]];
}

#pragma mark -

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self logAllKindOfCoreDataObjectsCount];
        
        WRSLoggedInUser *user = [[self allObjectsOfClass:NSStringFromClass([WRSLoggedInUser class])] firstObject];
        _loggedInUser = user;
        
        priortiesDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"priorties"] mutableCopy];
        if (!priortiesDictionary) {
            priortiesDictionary = [NSMutableDictionary new];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMainDataBase) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMainDataBase) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMainDataBase) name:UIApplicationWillResignActiveNotification object:nil];
        
        [self refreshWearableTypes];
    }
    
    return self;
}

#pragma mark - Shared 

-(void)refreshWearableTypes {
    
    _allPantTypes = [WRSWearable allPantTypes];
    _allShirtTypes = [WRSWearable allShirtTypes];
}

#pragma mark - Removing Objects

-(void)deleteUserAndRelatedData {
    
    [self.objectContext deleteObject:self.loggedInUser];
    [self saveMainDataBase];
}

-(void)removeBookmark:(WRSBookmark*)bookmark {
    
    if (bookmark) {
        
        [self.objectContext deleteObject:bookmark];
        [self saveDataBase];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyBookmarkChanged object:nil];
    }
}

-(void)removeBookmarkForPant:(WRSWearable*)pant andShirt:(WRSWearable*)shirt completion:(CompletionBlock)block {
    
    WRSBookmark *bookmark = [self bookMarkForPant:pant andShirt:shirt];
    if (bookmark) {
        
        [self.objectContext deleteObject:bookmark];
        
        [self saveDataBase];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyBookmarkChanged object:nil];
        
        if (block) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(@(YES), nil);
            });
        }
    }else {
        
        if (block) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSObject errorWithMessage:@"Can't be able delete bookmark.\nPlease try removing sometime later."];
                block(nil, error);
            });
        }
    }
}

-(void)removeWearableObject:(WRSWearable*)wearable {
    
    NSPredicate *predicateShirt = [NSPredicate predicateWithFormat:@"shirt == %@", wearable];
    NSPredicate *predicatePant = [NSPredicate predicateWithFormat:@"pant == %@", wearable];
    NSPredicate *combined = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicatePant, predicateShirt]];
    
    BOOL boookmarkChanged = NO;
    
    NSArray *bookmarked = [self.database allObjectsOfClass:NSStringFromClass([WRSBookmark class]) withPredicate:combined];
    for ( WRSBookmark *bookmark in bookmarked ) {
        
        boookmarkChanged = YES;
        [self.objectContext deleteObject:bookmark];
    }
    
    NSNumber *changedType = wearable.type;
    [self.objectContext deleteObject:wearable];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyWearableChanged object:changedType];
    
    if (boookmarkChanged) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyBookmarkChanged object:nil];
    }
}

#pragma mark - Priorties

-(void)savePriorties:(NSArray*)array forType:(WearableType)type {
    
    if (!array.count) {
        [priortiesDictionary removeObjectForKey:@(type).stringValue];
    }else {
        [priortiesDictionary setObject:array forKey:@(type).stringValue];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:priortiesDictionary forKey:@"priorties"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyPriortiesChanged object:@(type)];
}

-(NSArray*)priortiesForType:(WearableType)type {
    
    NSArray *priorties = priortiesDictionary[@(type).stringValue];
    if (!priorties) {
        if ([WRSWearable isPantType:type]) {
            priorties = [self.allShirtTypes copy];
        }
        else if ([WRSWearable isShirtType:type]) {
            priorties = [self.allPantTypes copy];
        }
    }
    
    return priorties;
}

#pragma mark - Bookmarks

-(WRSBookmark*)bookMarkForPant:(WRSWearable*)pant andShirt:(WRSWearable*)shirt {
    
    NSPredicate *predicateShirt = [NSPredicate predicateWithFormat:@"shirt == %@", shirt];
    NSPredicate *predicatePant = [NSPredicate predicateWithFormat:@"pant == %@", pant];
    NSPredicate *combined = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicatePant, predicateShirt]];
    
    NSArray *bookmarked = [self.database allObjectsOfClass:NSStringFromClass([WRSBookmark class]) withPredicate:combined];
    WRSBookmark *boorkmarked = [bookmarked firstObject];
    
    return boorkmarked;
}

-(void)addBookmarkForPant:(WRSWearable*)pant andShirt:(WRSWearable*)shirt completion:(CompletionBlock)block {
    
    if (pant && shirt) {
        
        WRSBookmark *bookmark = (WRSBookmark *)[self insertNewObjectOfClass:NSStringFromClass([WRSBookmark class])];
        bookmark.user = self.loggedInUser;
        bookmark.timestamp = @([[NSDate date] timeIntervalSince1970]);
        bookmark.shirt = shirt;
        bookmark.pant = pant;
        
        [self saveDataBase];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyBookmarkChanged object:bookmark];
        
        if (block) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                block(bookmark, nil);
            });
        }
    }else {
        
        if (block) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSObject errorWithMessage:@"Can't be able save bookmark.\nPlease try adding sometime later."];
                block(nil, error);
            });
        }
    }
}

#pragma mark - New Objects

-(void)insertNewUserWithID:(NSString*)uID andName:(NSString*)name {
    
    WRSLoggedInUser *user = (WRSLoggedInUser*)[self insertNewObjectOfClass:NSStringFromClass([WRSLoggedInUser class])];
    user.fbID = uID;
    user.name = name;
    
    _loggedInUser = user;
    [self saveMainDataBase];
}

-(NSManagedObject*)insertNewObjectOfClass:(NSString*)className {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:self.objectContext];
    return [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.objectContext];
}

-(void)addNewWearableOfType:(NSInteger)type andImage:(UIImage*)image completion:(CompletionBlock)block {
    
    [self.objectContext performBlock:^{
        
        if (image) {
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            NSData *data = UIImagePNGRepresentation(image);
            
            NSString *imagePath = nil;
            NSString *imageName = nil;
            
            do {
                
                NSInteger imageID = arc4random();
                imageName = [NSString stringWithFormat:@"%ld.png", (long)imageID];
                imagePath = [self imagePathForName:imageName];
            }while ([manager fileExistsAtPath:imagePath]);
            
            [data writeToFile:imagePath atomically:NO];
            
            NSString *thumbNail = [NSString stringWithFormat:@"thumb_%@", imageName];
            UIImage *t_image = [image thumbnailImageOfSize:CGSizeMake(100, 100)];
            NSData *t_data = UIImagePNGRepresentation(t_image);
            NSString *t_imagePath = [self imagePathForName:thumbNail];
            [t_data writeToFile:t_imagePath atomically:NO];
            
            WRSWearable *wearable = (WRSWearable *)[self insertNewObjectOfClass:NSStringFromClass([WRSWearable class])];
            wearable.user = self.loggedInUser;
            wearable.type = @(type);
            wearable.wearableID = imageName;
            wearable.relativeImageURL = imageName;
            wearable.thumbnailImageUrl = thumbNail;
            wearable.thumbnailSize = NSStringFromCGSize(t_image.size);
            
            [self saveDataBase];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyWearableChanged object:@(type)];
            
            if (block) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    block(wearable, nil);
                });
            }
        }else {
            
            if (block) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = [NSObject errorWithMessage:@"Can't be able read image file.\nPlease try adding image again."];
                    block(nil, error);
                });
            }
        }
    }];
    
}

#pragma mark - Retrive Core Data Objects

-(NSArray*)allObjectsOfClass:(NSString*)className {
    return [self allObjectsOfClass:className withPredicate:nil andSortDescriptor:nil];
}

-(NSArray*)allObjectsOfClass:(NSString*)className withPredicate:(NSPredicate*)predicate {
    return [self allObjectsOfClass:className withPredicate:predicate andSortDescriptor:nil];
}

-(NSArray*)allObjectsOfClass:(NSString*)className andSortDescriptor:(NSSortDescriptor*)sortDescri {
    return [self allObjectsOfClass:className withPredicate:nil andSortDescriptor:sortDescri];
}

- (NSArray*)allObjectsOfClass:(NSString*)className withPredicate:(NSPredicate*)predicate andSortDescriptor:(NSSortDescriptor*)sortDescri{
    
    return [self allObjectsOfClass:className withPredicate:predicate andSortDescriptor:sortDescri andLimit:0];
}

- (NSArray*)allObjectsOfClass:(NSString*)className withPredicate:(NSPredicate*)predicate andSortDescriptor:(NSSortDescriptor*)sortDescri andLimit:(NSInteger)limit{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    if (limit > 0) {
        [fetchRequest setFetchLimit:limit];
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:self.objectContext];
    [fetchRequest setEntity:entity];
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    if (sortDescri) {
        [fetchRequest setSortDescriptors:@[sortDescri]];
    }
    
    NSError *error = nil;
    return [self.objectContext executeFetchRequest:fetchRequest error:&error];
}

#pragma mark - CoreData

-(NSString*)imagePathForName:(NSString*)name {
    
    return [self.imagesDirectory URLByAppendingPathComponent:name].path;
}

- (void)saveDataBase {
    
    NSError *error = nil;
    [self.objectContext save:&error];
    if (error) {
        NSLog(@"Error Saving Background Context %@", error);
    }
}

- (void)saveMainDataBase {
    
    [self saveDataBase];
    
    NSError *error = nil;
    [self.mainContext save:&error];
    if (error) {
        NSLog(@"Error Saving Main Context %@", error);
    }
    NSLog(@"Main Database saved");
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WardrobeSelection" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [self.documentDirectory URLByAppendingPathComponent:@"WardrobeSelection.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)objectContext {
    
    if (!_objectContext) {
        _objectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_objectContext setParentContext:self.mainContext];
    }
    
    return _objectContext;
}

- (NSManagedObjectContext *)mainContext {
    
    if (!_mainContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_mainContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return _mainContext;
}

#pragma mark - Directory

-(NSURL *)documentDirectory {
    
    if (!_documentDirectory) {
        _documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }
    
    return _documentDirectory;
}

-(NSURL *)imagesDirectory {
    
    if (!_imagesDirectory) {
        
        _imagesDirectory = [self.documentDirectory URLByAppendingPathComponent:@"WearableImages"];
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:_imagesDirectory.path]) {
            [manager createDirectoryAtPath:_imagesDirectory.path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return _imagesDirectory;
}

@end
