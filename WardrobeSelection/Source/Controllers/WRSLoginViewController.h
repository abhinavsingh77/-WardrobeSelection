//
//  WRSLoginViewController.h
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRSUtility.h"

@interface WRSLoginViewController : UIViewController {
    
    IBOutlet UIButton *loginButton;
}

@property(nonatomic, strong) CompletionBlock completionBlock;

@end
