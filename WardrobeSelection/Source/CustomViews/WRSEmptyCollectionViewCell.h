//
//  WRSEmptyCollectionViewCell.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRSEmptyCollectionViewCell : UICollectionViewCell {
    
    IBOutlet UILabel *titleLabel;
}

-(void)showText:(id)text;

@end
