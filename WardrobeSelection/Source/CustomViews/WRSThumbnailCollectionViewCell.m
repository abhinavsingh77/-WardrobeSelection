//
//  WRSThumbnailCollectionViewCell.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 29/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSThumbnailCollectionViewCell.h"
#import "WRSDatabaseManager.h"

@implementation WRSThumbnailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)showDetailsOfWearable:(WRSWearable*)wearable {
    
    UIImage *imageShirt = [UIImage imageWithContentsOfFile:[self.database imagePathForName:wearable.thumbnailImageUrl]];
    thumbnailImageView.image = imageShirt;
}

@end
