//
//  WRSLoginViewController.m
//  WardrobeSelection
//
//  Created by Abhinav Singh on 25/09/15.
//  Copyright (c) 2015 No Organisation. All rights reserved.
//

#import "WRSLoginViewController.h"
#import "WRSFacebookHandler.h"

@interface WRSLoginViewController () {
    
    WRSFacebookHandler *handler;
}

@end

@implementation WRSLoginViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Login";
    
    loginButton.tintColor = [UIColor primaryColor];
    handler = [[WRSFacebookHandler alloc] init];
}

-(IBAction)loginClicked:(id)sender {
    
    [handler loginWithCompletion:^(id data, NSError *error) {
        
        if (error) {
            
            [NSObject showAlertForError:error];
        }else {
            
            if (self.completionBlock) {
                self.completionBlock(data, nil);
            }
        }
    }];
}

@end
