//
//  WRSWardrobeViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSWardrobeViewController.h"
#import "WRSUtility.h"
#import "WRSDatabaseManager.h"
#import "WRSTodaysPickViewController.h"
#import "WRSAddWearableHandler.h"
#import "WRSThumbnailCollectionViewCell.h"
#import "WRSEmptyCollectionViewCell.h"

@interface WRSWardrobeViewController () <WRSAddWearableHandlerDelegate> {
    
    WRSAddWearableHandler *wearableHandler;
}

@property(nonatomic, strong) NSFetchedResultsController *fetchController;

@end

@implementation WRSWardrobeViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"My Wardrobe";
    
    UIBarButtonItem *todaysPick = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddMore"]
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self
                                                                action:@selector(showTodaysSelectionController)];
    self.navigationItem.rightBarButtonItem = todaysPick;
    
    wearableHandler = [[WRSAddWearableHandler alloc] initWithDelegate:self];
    
    wardrobeCollectionView.backgroundColor = [UIColor whiteColor];
    
    [wardrobeCollectionView registerNib:[UINib nibWithNibName:@"WRSThumbnailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WRSThumbnailCollectionViewCell"];
    [wardrobeCollectionView registerNib:[UINib nibWithNibName:@"WRSEmptyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WRSEmptyCollectionViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWearables:) name:NotifyWearableChanged object:nil];
    
    [self createFetchController];
    [self refreshWearables:nil];
}

-(void)createFetchController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRSWearable class])];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES];
    [request setSortDescriptors:@[descriptor]];
    
    NSFetchedResultsController *fetchCont = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                managedObjectContext:self.database.objectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
    
    self.fetchController = fetchCont;
}

-(void)refreshWearables:(NSNotification*)notify {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.fetchController performFetch:nil];
        [wardrobeCollectionView reloadData];
    });
}

-(void)showTodaysSelectionController {
    
    WRSTodaysPickViewController *todays = [self controllerOfClass:[WRSTodaysPickViewController class]];
    [self.navigationController pushViewController:todays animated:YES];
}

#pragma mark - WRSAddWearableHandlerDelegate

-(UIViewController *)presentingContollerForHandler:(WRSAddWearableHandler *)handler {
    return self;
}

-(NSArray *)allWearableTypesThatCanBeAddedForHandler:(WRSAddWearableHandler *)handler {
    
    NSMutableArray *allWearableTypes = [NSMutableArray new];
    [allWearableTypes addObjectsFromArray:self.database.allPantTypes];
    [allWearableTypes addObjectsFromArray:self.database.allShirtTypes];
    
    return allWearableTypes;
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *retCell = nil;
    
    if (indexPath.row < self.fetchController.fetchedObjects.count) {
        
        WRSWearable *wearable = [self.fetchController objectAtIndexPath:indexPath];
        
        WRSThumbnailCollectionViewCell *cell = (WRSThumbnailCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WRSThumbnailCollectionViewCell" forIndexPath:indexPath];
        [cell showDetailsOfWearable:wearable];
        
        retCell = cell;
    }else {
        
        WRSEmptyCollectionViewCell *cell = (WRSEmptyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WRSEmptyCollectionViewCell" forIndexPath:indexPath];
        [cell showText:@"Looks like you don't have any wearables.\nTap here to add some?"];
        
        retCell = cell;
    }
    
    return retCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = self.fetchController.fetchedObjects.count;
    if (!count) {
        count = 1;
    }
    
    return count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.fetchController.fetchedObjects.count) {
        
        WRSWearable *wearable = [self.fetchController objectAtIndexPath:indexPath];
        return CGSizeFromString(wearable.thumbnailSize);
    }else {
        
        CGFloat avaliableHeight = ([UIScreen mainScreen].bounds.size.height-(64+49+20));
        CGSize cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, avaliableHeight);
        
        return cellSize;
    }
    
    return CGSizeZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSInteger count = 1;
    return count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.fetchController.fetchedObjects.count) {
        
        [wearableHandler showActionSheetToAddCollection];
    }
}

@end
