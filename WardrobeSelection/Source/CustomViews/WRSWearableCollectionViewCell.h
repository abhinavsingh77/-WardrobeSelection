//
//  WRSWearableCollectionViewCell.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRSWearable.h"

@interface WRSWearableCollectionViewCell : UICollectionViewCell {
    
    @public
    IBOutlet UIImageView *wearableImageView;
}

@property(nonatomic, readonly, strong) WRSWearable *displayedWearable;

-(void)showDetailsOfWearableObject:(WRSWearable*)wearable andSize:(CGSize)size isTopAllinged:(BOOL)topAlin;


@end
