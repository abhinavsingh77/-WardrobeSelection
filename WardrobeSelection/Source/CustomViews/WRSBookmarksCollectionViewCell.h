//
//  WRSBookmarksCollectionViewCell.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WRSBookmark;

@interface WRSBookmarksCollectionViewCell : UICollectionViewCell {

    IBOutlet UIImageView *shirtImageView;
    IBOutlet UIImageView *pantImageView;
}

-(void)showDetailsOfBookmark:(WRSBookmark*)bookmark cellSize:(CGSize)cellSize;


@end
