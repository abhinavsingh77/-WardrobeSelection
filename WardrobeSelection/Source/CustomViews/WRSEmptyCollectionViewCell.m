//
//  WRSEmptyCollectionViewCell.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 27/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSEmptyCollectionViewCell.h"
#import "WRSUtility.h"

@implementation WRSEmptyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor = [UIColor primaryColor];
    titleLabel.font = [UIFont wrsBoldFontOfSize:22];
}

-(void)showText:(id)text {
    
    if ([text isKindOfClass:[NSAttributedString class]]) {
        titleLabel.attributedText = text;
    }
    else if ([text isKindOfClass:[NSString class]]) {
        titleLabel.text = text;
    }
}

@end
