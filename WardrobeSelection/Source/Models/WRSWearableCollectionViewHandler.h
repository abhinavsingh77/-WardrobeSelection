//
//  WRSWearableCollectionViewHandler.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRSAddWearableHandler.h"

@import UIKit;
@import CoreData;


@class WRSWearableCollectionViewHandler, WRSWearable;

@protocol WRSWearableCollectionViewHandlerDelegate <NSObject>

-(UIViewController*)viewControllerForAddingNewWearablesForHandler:(WRSWearableCollectionViewHandler*)handler;
-(void)wearableSelectionChangedTo:(WRSWearable*)wearable forHandler:(WRSWearableCollectionViewHandler*)handler;
-(void)sortPairForWearableType:(NSNumber*)wearableType forHandler:(WRSWearableCollectionViewHandler*)handler;

@end

@interface WRSWearableCollectionViewHandler : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, WRSAddWearableHandlerDelegate> {
    
    WRSAddWearableHandler *wearableHandler;
    NSArray *allVisibleTypes;
    
    UICollectionView *wearableCollectionView;
    CGSize cellSize;
    BOOL isShowingShirts;
}

@property(nonatomic, weak) id <WRSWearableCollectionViewHandlerDelegate> delegate;

-(instancetype)initWithTypes:(NSArray*)types andCollectionView:(UICollectionView*)collection;
-(WRSWearable*)displayedWearableObjectAtIndex:(NSInteger)pageIndex;

-(void)shortForWearableType:(NSNumber*)wearableType;

@end