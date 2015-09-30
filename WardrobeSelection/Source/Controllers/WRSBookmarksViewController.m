//
//  WRSBookmarksViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSBookmarksViewController.h"
#import "WRSBookmark.h"
#import "WRSDatabaseManager.h"
#import "WRSEmptyCollectionViewCell.h"
#import "WRSBookmarksCollectionViewCell.h"
#import "WRSTodaysPickViewController.h"

@import CoreData;

@interface WRSBookmarksViewController () {
    
    CGSize cellSize;
    NSArray *rightBarItems;
}

@property(nonatomic, strong) NSFetchedResultsController *fetchController;


@end

@implementation WRSBookmarksViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Bookmarks";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBookmarks:) name:NotifyBookmarkChanged object:nil];
    
    UIBarButtonItem *makeUnFavouriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FavouriteSelected"]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(unFavouriteClicked:)];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ShareIcon"]
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(shareClicked:)];
    rightBarItems = @[shareButton, makeUnFavouriteButton];
    
    bookmarksCollectionView.backgroundColor = [UIColor whiteColor];
    
    CGFloat avaliableHeight = ([UIScreen mainScreen].bounds.size.height-(64+49));
    
    cellSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, avaliableHeight);
    
    [bookmarksCollectionView registerNib:[UINib nibWithNibName:@"WRSEmptyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WRSEmptyCollectionViewCell"];
    [bookmarksCollectionView registerNib:[UINib nibWithNibName:@"WRSBookmarksCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WRSBookmarksCollectionViewCell"];
    
    [bookmarksCollectionView setPagingEnabled:YES];
    
    [self createFetchController];
    [self refreshBookmarks:nil];
}

-(void)refreshBookmarks:(NSNotification*)notify{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.fetchController performFetch:nil];
        [bookmarksCollectionView reloadData];
        
        if (!self.fetchController.fetchedObjects.count) {
            self.navigationItem.rightBarButtonItems = nil;
        }else {
            self.navigationItem.rightBarButtonItems = rightBarItems;
        }
    });
}

-(void)createFetchController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([WRSBookmark class])];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [request setSortDescriptors:@[descriptor]];
    
    NSFetchedResultsController *fetchCont = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                managedObjectContext:self.database.objectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
    
    self.fetchController = fetchCont;
}

-(void)unFavouriteClicked:(UIBarButtonItem*)item {
    
    NSInteger page = (bookmarksCollectionView.contentOffset.x/cellSize.width);
    
    if (page < self.fetchController.fetchedObjects.count) {
        
        WRSBookmark *bookmark = [self.fetchController objectAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
        [self.database removeBookmark:bookmark];
    }
}

-(void)shareClicked:(UIBarButtonItem*)item {
    
    NSArray *visible = [bookmarksCollectionView visibleCells];
    WRSBookmarksCollectionViewCell *cell = [visible firstObject];
    if ([cell isKindOfClass:[WRSBookmarksCollectionViewCell class]]) {
        
        UIImage *image = [cell snapShotImage];
        if (image) {
            
            NSString* string = @"How this combination looks!";
            NSMutableArray *sharingItems = [NSMutableArray new];
            [sharingItems addObject:string];
            
            [sharingItems addObject:image];
            
            UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
            [self presentViewController:activityController animated:YES completion:nil];
        }
    }
}

#pragma mark UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *retCell = nil;
    
    if (indexPath.row < self.fetchController.fetchedObjects.count) {
        
        WRSBookmark *bookmark = [self.fetchController objectAtIndexPath:indexPath];
        
        WRSBookmarksCollectionViewCell *cell = (WRSBookmarksCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WRSBookmarksCollectionViewCell" forIndexPath:indexPath];
        [cell showDetailsOfBookmark:bookmark cellSize:cellSize];
        
        retCell = cell;
    }else {
        
        WRSEmptyCollectionViewCell *cell = (WRSEmptyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WRSEmptyCollectionViewCell" forIndexPath:indexPath];
        [cell showText:@"Looks like you don't have more bookmarks.\nTap here to add some?"];
        
        retCell = cell;
    }
    
    return retCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = self.fetchController.fetchedObjects.count;
    count += 1;
    return count;
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
    
    if (indexPath.row >= self.fetchController.fetchedObjects.count) {
        
        WRSTodaysPickViewController *todays = [self controllerOfClass:[WRSTodaysPickViewController class]];
        [self.navigationController pushViewController:todays animated:YES];
    }
}

@end
