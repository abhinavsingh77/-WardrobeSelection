//
//  WRSThumbnailCollectionViewCell.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 29/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRSWearable.h"

@interface WRSThumbnailCollectionViewCell : UICollectionViewCell {
    
    IBOutlet UIImageView *thumbnailImageView;
}

-(void)showDetailsOfWearable:(WRSWearable*)wearable;

@end
