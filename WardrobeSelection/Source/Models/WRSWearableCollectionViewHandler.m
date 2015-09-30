//
//  WRSWearableCollectionViewHandler.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSWearableCollectionViewHandler.h"
#import "WRSWearable.h"
#import "WRSDatabaseManager.h"
#import "WRSWearableCollectionViewCell.h"
#import "WRSEmptyCollectionViewCell.h"

@interface WRSWearableCollectionViewHandler ()

@property(nonatomic, strong) NSMutableArray *allObjects;

@end

@implementation WRSWearableCollectionViewHandler

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTypes:(NSArray*)types andCollectionView:(UICollectionView*)collection {
    
    self = [super init];
    if (self) {
        
        allVisibleTypes = types;
        
        isShowingShirts = NO;
        NSNumber *first = [allVisibleTypes firstObject];
        if ([WRSWearable isShirtType:first.integerValue]) {
            isShowingShirts = YES;
        }
        
        wearableHandler = [[WRSAddWearableHandler alloc] initWithDelegate:self];
        
        collection.delegate = self;
        collection.dataSource = self;
        
        collection.backgroundColor = [UIColor whiteColor];
        
        CGFloat avaliableHeight = ([UIScreen mainScreen].bounds.size.height-(64+49));//NavigaionBar + Tabbar Height
        
        cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, avaliableHeight/2.0f);
        
        [collection registerNib:[UINib nibWithNibName:@"WRSWearableCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WRSWearableCollectionViewCell"];
        [collection registerNib:[UINib nibWithNibName:@"WRSEmptyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WRSEmptyCollectionViewCell"];
        
        [collection setPagingEnabled:YES];
        
        NSPredicate *defaultPredicate = [NSPredicate predicateWithFormat:@"type IN %@", allVisibleTypes];
        self.allObjects = [[self.database allObjectsOfClass:NSStringFromClass([WRSWearable class]) withPredicate:defaultPredicate] mutableCopy];
        
        wearableCollectionView = collection;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshObjects:) name:NotifyWearableChanged object:nil];
    }
    
    return self;
}

-(void)refreshObjects:(NSNotification*)notify {
    
    NSNumber *typeAdded = notify.object;
    if ([allVisibleTypes containsObject:typeAdded]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSPredicate *defaultPredicate = [NSPredicate predicateWithFormat:@"type IN %@", allVisibleTypes];
            self.allObjects = [[self.database allObjectsOfClass:NSStringFromClass([WRSWearable class]) withPredicate:defaultPredicate] mutableCopy];
            
            [wearableCollectionView reloadData];
            [self sendSelectionChangeCallback];
        });
    }
}

-(void)shortForWearableType:(NSNumber*)wearableType {
    
    NSArray *priorties = [self.database priortiesForType:wearableType.integerValue];
    [self.allObjects sortUsingComparator:^NSComparisonResult(WRSWearable *obj1, WRSWearable *obj2) {
        
        NSComparisonResult result = [@([priorties indexOfObject:obj1.type]) compare:@([priorties indexOfObject:obj2.type])];
        return result;
    }];
    
    [wearableCollectionView reloadData];
    [self sendSelectionChangeCallback];
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *retCell = nil;
    
    if (indexPath.row < self.allObjects.count) {
        
        WRSWearable *wearable = self.allObjects[indexPath.row];
        
        WRSWearableCollectionViewCell *cell = (WRSWearableCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WRSWearableCollectionViewCell" forIndexPath:indexPath];
        [cell showDetailsOfWearableObject:wearable andSize:cellSize isTopAllinged:!isShowingShirts];
        
        retCell = cell;
    }else {
        
        WRSEmptyCollectionViewCell *cell = (WRSEmptyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WRSEmptyCollectionViewCell" forIndexPath:indexPath];
        [cell showText:@"Looks like you don't have options anymore.\n Tap here to add some?"];
        retCell = cell;
    }
    
    return retCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = self.allObjects.count;
    
    return (count+1);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellSize;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSInteger count = 1;
    return count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.allObjects.count) {
        
        [wearableHandler showActionSheetToAddCollection];
    }else {
        
        WRSWearable *wearable = self.allObjects[indexPath.row];
        
        NSArray *actions = nil;
        
        NSString *priortyActionString = nil;
        NSString *shareActionString = nil;
        
        if (isShowingShirts) {
            
            priortyActionString = @"Show preferred pants for this shirt";
            shareActionString = @"Show this shirt";
        }else {
            priortyActionString = @"Show preferred shirts for this pant";
            shareActionString = @"Share this pant";
        }
        
        UIAlertAction *actionPriorty = [UIAlertAction actionWithTitle:priortyActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.delegate sortPairForWearableType:wearable.type forHandler:self];
        }];
        
        UIAlertAction *actionShare = [UIAlertAction actionWithTitle:shareActionString style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            WRSWearableCollectionViewCell *cell = (WRSWearableCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            UIImage *image = [cell->wearableImageView snapShotImage];
            if (image) {
                
                NSString* string = @"How it looks!";
                NSMutableArray *sharingItems = [NSMutableArray new];
                [sharingItems addObject:string];
                
                [sharingItems addObject:image];
                
                UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
                [[self.delegate viewControllerForAddingNewWearablesForHandler:self] presentViewController:activityController animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *actionRemove = [UIAlertAction actionWithTitle:@"Remove this from database" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            [self.database removeWearableObject:wearable];
        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        actions = @[actionPriorty, actionShare, actionRemove, actionCancel];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wardrobe Collection"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        for (UIAlertAction *action in actions) {
            [alert addAction:action];
        }
        
        [[self.delegate viewControllerForAddingNewWearablesForHandler:self] presentViewController:alert animated:YES completion:nil];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self sendSelectionChangeCallback];
}

-(WRSWearable*)displayedWearableObjectAtIndex:(NSInteger)pageIndex {
    
    WRSWearable *displayedWearable = nil;
    if (pageIndex < self.allObjects.count) {
        
        WRSWearable *wearable = self.allObjects[pageIndex];
        displayedWearable = wearable;
    }
    
    return displayedWearable;
}

-(void)sendSelectionChangeCallback {
    
    NSInteger page = (wearableCollectionView.contentOffset.x/cellSize.width);
    
    WRSWearable *displayedWearable = [self displayedWearableObjectAtIndex:page];
    [self.delegate wearableSelectionChangedTo:displayedWearable forHandler:self];
}

#pragma mark - WRSAddWearableHandlerDelegate

-(UIViewController *)presentingContollerForHandler:(WRSAddWearableHandler *)handler {
    
    return [self.delegate viewControllerForAddingNewWearablesForHandler:self];
}

-(NSArray *)allWearableTypesThatCanBeAddedForHandler:(WRSAddWearableHandler *)handler {
    
    return allVisibleTypes;
}

@end