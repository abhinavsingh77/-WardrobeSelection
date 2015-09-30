//
//  WRSRootViewController.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

@import UIKit;

#import "WRSDatabaseManager.h"

@interface WRSRootViewController : UIViewController { }

@property(readonly, strong) WRSDatabaseManager *dbManager;
-(void)logoutCurrentUser;

@end
