//
//  WRSTodaysPickViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 26/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSTodaysPickViewController.h"
#import "WRSWearableCollectionViewHandler.h"
#import "WRSDatabaseManager.h"
#import "WRSBookmark.h"

@interface WRSTodaysPickViewController () <WRSWearableCollectionViewHandlerDelegate>{
    
    WRSWearableCollectionViewHandler *shirtsCollectionDelegate;
    WRSWearableCollectionViewHandler *pantCollectionDelegate;
    
    WRSWearable *currentPant;
    WRSWearable *currentShirt;
    
    UIBarButtonItem *makeFavouriteButton;
    UIBarButtonItem *makeUnFavouriteButton;
}

@end

@implementation WRSTodaysPickViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Selections";
    
    shirtsCollectionDelegate = [[WRSWearableCollectionViewHandler alloc] initWithTypes:self.database.allShirtTypes andCollectionView:topCollectionView];
    shirtsCollectionDelegate.delegate = self;
    
    pantCollectionDelegate = [[WRSWearableCollectionViewHandler alloc] initWithTypes:self.database.allPantTypes andCollectionView:bottomCollectionView];
    pantCollectionDelegate.delegate = self;
    
    makeUnFavouriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FavouriteSelected"]
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(unFavouriteClicked:)];
    
    makeFavouriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FavouriteUnSelected"]
                                                           style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(favouriteClicked:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFavouriteButtonStatus) name:NotifyBookmarkChanged object:nil];
    
    currentPant = [pantCollectionDelegate displayedWearableObjectAtIndex:0];
    currentShirt = [shirtsCollectionDelegate displayedWearableObjectAtIndex:0];
    
    [self changeFavouriteButtonStatus];
}

-(void)favouriteClicked:(UIBarButtonItem*)item {
    
    [self.database addBookmarkForPant:currentPant andShirt:currentShirt completion:nil];
}

-(void)unFavouriteClicked:(UIBarButtonItem*)item {
    
    [self.database removeBookmarkForPant:currentPant andShirt:currentShirt completion:nil];
}

-(void)changeFavouriteButtonStatus {
    
    BOOL isSelectionBookmarked = NO;
    if (currentShirt && currentPant) {
        
        WRSBookmark *bookmark = [self.database bookMarkForPant:currentPant andShirt:currentShirt];
        if (bookmark) {
            isSelectionBookmarked = YES;
        }
    }
    
    if (isSelectionBookmarked) {
        self.navigationItem.rightBarButtonItem = makeUnFavouriteButton;
    }else if (currentShirt && currentPant) {
        self.navigationItem.rightBarButtonItem = makeFavouriteButton;
    }else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark WRSWearableCollectionViewHandlerDelegate Methods

-(void)sortPairForWearableType:(NSNumber *)wearableType forHandler:(WRSWearableCollectionViewHandler *)handler {
    
    if ([handler isEqual:pantCollectionDelegate]) {
        [shirtsCollectionDelegate shortForWearableType:wearableType];
    }else if ([handler isEqual:shirtsCollectionDelegate]) {
        [pantCollectionDelegate shortForWearableType:wearableType];
    }
}

-(UIViewController *)viewControllerForAddingNewWearablesForHandler:(WRSWearableCollectionViewHandler *)handler {
    
    return self;
}

-(void)wearableSelectionChangedTo:(WRSWearable *)wearable forHandler:(WRSWearableCollectionViewHandler *)handler {
    
    if ([handler isEqual:pantCollectionDelegate]) {
        currentPant = wearable;
    }else if ([handler isEqual:shirtsCollectionDelegate]) {
        currentShirt = wearable;
    }
    
    [self changeFavouriteButtonStatus];
}

@end
