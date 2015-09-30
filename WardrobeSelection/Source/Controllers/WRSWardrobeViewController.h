//
//  WRSWardrobeViewController.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRSWardrobeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>{
    
    IBOutlet UICollectionView *wardrobeCollectionView;
}

@end
