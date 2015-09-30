//
//  WRSBookmarksCollectionViewCell.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSBookmarksCollectionViewCell.h"
#import "WRSDatabaseManager.h"
#import "WRSBookmark.h"
#import "WRSWearable.h"

@implementation WRSBookmarksCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    shirtImageView.autoresizingMask = UIViewAutoresizingNone;
    pantImageView.autoresizingMask = UIViewAutoresizingNone;
}

-(void)showDetailsOfBookmark:(WRSBookmark*)bookmark cellSize:(CGSize)cellSize{
    
    UIImage *imageShirt = [UIImage imageWithContentsOfFile:[self.database imagePathForName:bookmark.shirt.relativeImageURL]];
    CGSize shirtImageSize = [UIView sizeThatFitsInSize:CGSizeMake(cellSize.width, cellSize.height/2) mantaingRatioOfSize:imageShirt.size];
    
    shirtImageView.frame = CGRectMake((cellSize.width-shirtImageSize.width)/2, (cellSize.height/2)-shirtImageSize.height, shirtImageSize.width, shirtImageSize.height);
    
    UIImage *imagePant = [UIImage imageWithContentsOfFile:[self.database imagePathForName:bookmark.pant.relativeImageURL]];
    CGSize pantImageSize = [UIView sizeThatFitsInSize:CGSizeMake(cellSize.width, cellSize.height/2) mantaingRatioOfSize:imagePant.size];
    
    pantImageView.frame = CGRectMake((cellSize.width-pantImageSize.width)/2, shirtImageView.maxY, pantImageSize.width, pantImageSize.height);
    
    shirtImageView.image = imageShirt;
    pantImageView.image = imagePant;
}

@end
