//
//  WRSPriortySelectionViewController.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 26/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRSUtility.h"
#import "WRSDatabaseManager.h"

@interface WRSPriortySelectionViewController : UIViewController {
    
    IBOutlet UITableView *theTableView;
}

@property(nonatomic, strong) SuccessBlock completionBlock;
@property(nonatomic, assign) WearableType type;

@end
