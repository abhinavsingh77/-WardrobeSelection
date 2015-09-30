//
//  WRSWearableCollectionViewCell.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSWearableCollectionViewCell.h"
#import "WRSWearable.h"
#import "WRSDatabaseManager.h"

@implementation WRSWearableCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    wearableImageView.autoresizingMask = UIViewAutoresizingNone;
}

-(void)showDetailsOfWearableObject:(WRSWearable*)wearable andSize:(CGSize)size isTopAllinged:(BOOL)topAlin {
    
    _displayedWearable = wearable;
    
    UIImage *image = [UIImage imageWithContentsOfFile:[self.database imagePathForName:wearable.relativeImageURL]];
    CGSize imageViewSize = [UIView sizeThatFitsInSize:size mantaingRatioOfSize:image.size];
    
    wearableImageView.image = image;
    
    if (topAlin) {
        wearableImageView.frame = CGRectMake((size.width-imageViewSize.width)/2, 0, imageViewSize.width, imageViewSize.height);
    }else {
        wearableImageView.frame = CGRectMake((size.width-imageViewSize.width)/2, size.height-imageViewSize.height, imageViewSize.width, imageViewSize.height);
    }
}

@end
